(**
  
  This module contains a dialogue for configuring which forms/windows in the IDE are updated.

  @Author  David Hoyle
  @Version 1.088
  @Date    06 Jan 2022
  
  @license
  
    DGH IDE Fonts is a RAD Studio plug-in to provide the ability to change the
    size of the fonts in the IDE.
    
    Copyright (C) 2022  David Hoyle (https://github.com/DGH2112/IDE-Fonts/)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License

**)
Unit DGHIDEFonts.WindowDlg;

Interface

Uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Buttons,
  ComCtrls,
  ImgList,
  ExtCtrls;

{$INCLUDE CompilerDefinitions.inc}

Type
  (** A record to describe the settings. **)
  TDGHIDEFontSettings = Record
    FFontName         : String;
    FFontSize         : Integer;
    FParentFont       : Boolean;
    FUpdateInterval   : Integer;
    FFormFontColour   : TColor;
    FFontAttrColour   : TColor;
    FParentFontColour : TColor;
  End;

  (** A class which presents a form for querying the user for the windows to update. **)
  TfrmWindowDlg = Class(TForm)
    Label1: TLabel;
    lvWindowList: TListView;
    cbxFontName: TComboBox;
    edtFontSize: TEdit;
    udFontSize: TUpDown;
    chkParentFont: TCheckBox;
    lblDelayInterval: TLabel;
    edtDelayInterval: TEdit;
    udDelayInterval: TUpDown;
    btnOK: TButton;
    btnCancel: TButton;
    ilButtonImages: TImageList;
    lblFormFontColour: TLabel;
    cbxFormFontColour: TColorBox;
    cbxFontAttrColour: TColorBox;
    lblFontAttrColour: TLabel;
    cbxParentFontColour: TColorBox;
    lblParentFontColour: TLabel;
    pnlFudgePanel: TPanel;
  Strict Private
  Strict Protected
    Procedure InitialiseDlg(Const slWindowList : TStringList; Var Settings : TDGHIDEFontSettings);
    Procedure FinaliseDlg(Const slWindowList : TStringList; Var Settings : TDGHIDEFontSettings);
  Public
    { Public declarations }
    Class Function Execute(Const slWindowList : TStringList; Var Settings : TDGHIDEFontSettings) : Boolean;
  End;

Implementation

Uses
  ToolsAPI,
  Math;

{$R *.dfm}

(**

  This method displays the window list dialogue to allow the user to select the window he or she wishes 
  the change the font size of.

  @precon  slWindowList must be a valid instance.
  @postcon The dialogue is displayed.

  @param   slWindowList as a TStringList as a constant
  @param   Settings     as a TDGHIDEFontSettings as a reference
  @return  a Boolean

**)
Class Function TfrmWindowDlg.Execute(Const slWindowList: TStringList;
  Var Settings : TDGHIDEFontSettings): Boolean;

Var
  F: TfrmWindowDlg;
  {$IFDEF RS102}
  ITS : IOTAIDEThemingServices250;
  {$ENDIF RS102}

Begin
  Result := False;
  F := TfrmWindowDlg.Create(Application.MainForm);
  Try
    {$IFDEF RS102}
    If Supports(BorlandIDEServices, IOTAIDEThemingServices250, ITS) Then
      If ITS.IDEThemingEnabled Then
        Begin
          ITS.RegisterFormClass(TfrmWindowDlg);
          ITS.ApplyTheme(F);
        End;
    {$ENDIF RS102}
    F.InitialiseDlg(slWindowList, Settings);
    If F.ShowModal = mrOK Then
      Begin
        F.FinaliseDlg(slWindowList, Settings);
        Result := True;
      End;
  Finally
    F.Free;
  End;
End;

(**

  This method reads the dialogues controls and updates the window list and font name an size accordingly.

  @precon  slWindowList must be a valid instance.
  @postcon The window list and font name and size parameters are updated.

  @param   slWindowList as a TStringList as a constant
  @param   Settings     as a TDGHIDEFontSettings as a reference

**)
Procedure TfrmWindowDlg.FinaliseDlg(Const slWindowList : TStringList;
  Var Settings : TDGHIDEFontSettings);

Var
  i: Integer;
  
Begin
  Settings.FParentFont := chkParentFont.Checked;
  Settings.FFontName := cbxFontName.Text;
  Settings.FFontSize := udFontSize.Position;
  Settings.FUpdateInterval := udDelayInterval.Position;
  Settings.FFormFontColour := cbxFormFontColour.Selected;
  Settings.FFontAttrColour := cbxFontAttrColour.Selected;
  Settings.FParentFontColour := cbxParentFontColour.Selected;
  For i := 0 To slWindowList.Count - 1 Do
    slWindowList.Objects[i] := TObject(IfThen(lvWindowList.Items[i].Checked, 1, 0));
End;

(**

  This method loads the dialogue with a list of window names and class names and sets the font name and 
  size controls.

  @precon  slWindowList must be a valid instance.
  @postcon The dialogue is initialised.

  @param   slWindowList as a TStringList as a constant
  @param   Settings     as a TDGHIDEFontSettings as a reference

**)
Procedure TfrmWindowDlg.InitialiseDlg(Const slWindowList : TStringList;
  Var Settings : TDGHIDEFontSettings);

Var
  i: Integer;
  ListItem: TListItem;

Begin
  chkParentFont.Checked := Settings.FParentFont;
  For i := 0 To Screen.Fonts.Count - 1 Do
    cbxFontName.Items.Add(Screen.Fonts[i]);
  cbxFontName.ItemIndex := cbxFontName.Items.IndexOf(Settings.FFontName);
  udFontSize.Position := Settings.FFontSize;
  udDelayInterval.Position := Settings.FUpdateInterval;
  cbxFormFontColour.Selected := Settings.FFormFontColour;
  cbxFontAttrColour.Selected := Settings.FFontAttrColour;
  cbxParentFontColour.Selected := Settings.FParentFontColour;
  lvWindowList.Items.BeginUpdate;
  Try
    For i := 0 To slWindowList.Count - 1 Do
      Begin
        ListItem := lvWindowList.Items.Add;
        ListItem.Caption := slWindowList.Names[i];
        ListItem.SubItems.Add(slWindowList.ValueFromIndex[i]);
        ListItem.Checked := Assigned(slWindowList.Objects[i]);
      End;
  Finally
    lvWindowList.Items.EndUpdate;
  End;
End;

End.
