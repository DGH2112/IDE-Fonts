(**
  
  This module contains a dialogue for configuring which windiws in the IDE are updated.

  @Author  David Hoyle
  @Version 1.0
  @Date    30 Jun 2018
  
**)
Unit DGHIDEFonts.WindowDlg;

Interface

Uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ComCtrls;

Type
  (** A record to describe the settings. **)
  TDGHIDEFontSettings = Record
    FFontName       : String;
    FFontSize       : Integer;
    FParentFont     : Boolean;
    FUpdateInterval : Integer;
  End;

  (** A class which presents a form for querying the user for the windows to update. **)
  TfrmWindowDlg = Class(TForm)
    Label1: TLabel;
    lvWindowList: TListView;
    cbxFontName: TComboBox;
    edtFontSize: TEdit;
    udFontSize: TUpDown;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    chkParentFont: TCheckBox;
    lblDelayInterval: TLabel;
    edtDelayInterval: TEdit;
    udDelayInterval: TUpDown;
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
  System.Math;

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

Begin
  Result := False;
  F := TfrmWindowDlg.Create(Application.MainForm);
  Try
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
  Settings.FUpdateInterval := udFontSize.Position;
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
