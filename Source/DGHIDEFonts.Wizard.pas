(**
  
  This module defines the main wizard interface for this RAD Studio IDE expert.

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
Unit DGHIDEFonts.Wizard;

Interface

Uses
  ToolsAPI,
  Classes,
  ExtCtrls,
  Forms,
  DGHIDEFonts.Interfaces,
  DGHIDEFonts.WindowDlg;

Type
  (** A class which implements the IOTAWizard and IOTAMenuWizard interfaces for the RAD Studio IDE
      expert. **)
  TDGHIDEFontWizard = Class(TInterfacedObject, IUnknown, IOTANotifier, IOTAWizard, IOTAMenuWizard)
  Strict Private
    FINIFileName : String;
    FWindowList  : TStringList;
    FSettings    : TDGHIDEFontSettings;
    FHasRunBefore: Boolean;
    FStartTimer  : TTimer;
    FInterval    : Integer;
  Strict Protected
    // IOTAWizard
    Procedure Execute;
    Function  GetIDString: String;
    Function  GetName: String;
    Function  GetState: TWizardState;
    Procedure AfterSave;
    Procedure BeforeSave;
    procedure BuildINIFileName;
    Procedure Destroyed;
    Procedure Modified;
    // IOTAMenuWizard
    Function  GetMenuText: String;
    // General Method
    Procedure LoadSettings;
    Procedure SaveSettings;
    Procedure LoadWindowList;
    Procedure SaveWindowList;
    Procedure UpdateWindows;
    Procedure UpdateParentFont(Const F : TForm; Var ParentMsg : IDGHIDEFontCustomMessage);
    Procedure OutputFormMsg(Var ParentMsg : IDGHIDEFontCustomMessage; Const F : TForm);
    // Event Handlers
    Procedure StartTimerEvent(Sender : TObject);
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End;

  Function InitWizard(Const BorlandIDEServices : IBorlandIDEServices; RegisterProc : TWizardRegisterProc;
    var Terminate: TWizardTerminateProc) : Boolean; StdCall;

Exports
  InitWizard Name WizardEntryPoint;
  
Implementation

Uses
  {$IFDEF DEBUG}
  //: @debug CodeSiteLogging,
  {$ENDIF}
  SysUtils,
  RTTI,
  INIFiles,
  Controls,
  Graphics,
  Windows,
  ShlObj,
  DGHIDEFonts.Functions,
  DGHIDEFonts.SplashScreen;

Const
  (** A constant for the INI section name for storing the settings. **)
  strSetupINISection = 'Setup';
  (** An INI key name for the Font Name. **)
  strHasRunBeforeKey = 'HasRunBefore';
  (** An INI key name for whether the expert has run before. **)
  strFontNameKey = 'FontName';
  (** An INI key name for the Font Size. **)
  strFontSizeKey = 'FontSize';
  (** An INI Section name for the Window List **)
  strWindowListINISection = 'WindowList';
  (** An INI key for the parent font settings. **)
  strParentFontKey = 'ParentFont';
  (** An INI key for the delay interval settings. **)
  strIntervalKey = 'Interval';
  (** An INI key for the colour of the form message. **)
  strFormFontColourKey = 'FormFontColour';
  (** An INI key for the colour of the font attribute message. **)
  strFontAttrColourKey = 'FontAttrColour';
  (** An INI key for the colour of the Parent Font message. **)
  strParentFontColourKey = 'ParentFontColour';

(**

  This function returns the users computer name as a String.

  @precon  None.
  @postcon Returns the users computer name as a String.

  @return  a String

**)
Function ComputerName : String;

Var
  iSize : Cardinal;

Begin
  iSize := MAX_PATH;
  SetLength(Result, iSize);
  GetComputerName(@Result[1], iSize);
  Win32Check(LongBool(iSize));
  SetLength(Result, iSize);
End;

(**

  This is a procedure to initialising the wizard interface when loading as a DLL wizard.

  @precon  None.
  @postcon Initialises the wizard.

  @nocheck MissingCONSTInParam
  @nohint  Terminate

  @param   BorlandIDEServices as an IBorlandIDEServices as a constant
  @param   RegisterProc       as a TWizardRegisterProc
  @param   Terminate          as a TWizardTerminateProc as a reference
  @return  a Boolean

**)
Function InitWizard(Const BorlandIDEServices : IBorlandIDEServices;
  RegisterProc : TWizardRegisterProc;
  var Terminate: TWizardTerminateProc) : Boolean; StdCall; //FI:O804

Begin
  Result := Assigned(BorlandIDEServices);
  If Result Then
    RegisterProc(TDGHIDEFontWizard.Create);
End;

(**

  This function returns the users log-on name as a String.

  @precon  None.
  @postcon Returns the users log-on name as a String.

  @return  a String

**)
Function UserName : String;

Var
  iSize : Cardinal;

Begin
  iSize := MAX_PATH;
  SetLength(Result, iSize);
  GetUserName(@Result[1], iSize);
  Win32Check(LongBool(iSize));
  SetLength(Result, iSize - 1);
End;

(**

  This is an AfterSave event handler for the Wizard interface.

  @precon  None.
  @postcon Does nothing.

  @nocheck EmptyMethod

**)
Procedure TDGHIDEFontWizard.AfterSave;

Begin //FI:W519
End;

(**

  This is an BeforeSave event handler for the Wizard interface.

  @precon  None.
  @postcon Does nothing.

  @nocheck EmptyMethod

**)
Procedure TDGHIDEFontWizard.BeforeSave;

Begin //FI:W519
End;

(**

  This method build an INNI Filename for the application in the users profile with their username
  and computer name for uniqueness.

  @precon  None.
  @postcon The INI Filename is constructed.

**)
Procedure TDGHIDEFontWizard.BuildINIFileName;

Const
  strINIPattern = '%s Settings for %s on %s.INI';
  strSeasonsFall = '\Season''s Fall\';

Var
  strUserAppDataPath: String;
  strBuffer: String;
  iSize: Integer;

Begin
  SetLength(strBuffer, MAX_PATH);
  iSize := GetModuleFileName(hInstance, PChar(strBuffer), MAX_PATH);
  SetLength(strBuffer, iSize);
  FINIFileName := ChangeFileExt(ExtractFileName(strBuffer), '');
  FINIFileName := Format(strINIPattern, [FINIFileName, UserName, ComputerName]);
  SetLength(strBuffer, MAX_PATH);
  SHGetFolderPath(0, CSIDL_APPDATA Or CSIDL_FLAG_CREATE, 0, SHGFP_TYPE_CURRENT, PChar(strBuffer));
  strBuffer := StrPas(PChar(strBuffer));
  strUserAppDataPath := strBuffer + strSeasonsFall;
  If Not DirectoryExists(strUserAppDataPath) Then
    ForceDirectories(strUserAppDataPath);
  FINIFileName := strUserAppDataPath + FINIFileName;
End;

(**

  A constructor for the TDGHIDEFontWizard class.

  @precon  None.
  @postcon Adds a splash screen to the IDE.

**)
Constructor TDGHIDEFontWizard.Create;

Const
  iStartTimerInterval = 1000;

Begin
  BuildINIFileName;
  LoadSettings;
  TDGHIDEFontSplashScreen.AddSplashScreen;
  FWindowList := TStringList.Create;
  FInterval := 0;
  FStartTimer := TTimer.Create(Nil);
  FStartTimer.Interval := iStartTimerInterval;
  FStartTimer.Enabled := True;
  FStartTimer.OnTimer := StartTimerEvent;
End;

(**

  A destructor for the TDGHIDEFontWizard class.

  @precon  None.
  @postcon Frees the memory used by the expert.

**)
Destructor TDGHIDEFontWizard.Destroy;

Begin
  FStartTimer.Free;
  SaveSettings;
  FWindowList.Free;
  Inherited Destroy;
End;

(**

  This is an Destroyed event handler for the Wizard interface.

  @precon  None.
  @postcon Does nothing.

  @nocheck EmptyMethod

**)
Procedure TDGHIDEFontWizard.Destroyed;

Begin //FI:W519
End;

(**

  This method invokes the experts functionality to change the font name and size of the IDEs windows.

  @precon  None.
  @postcon Contains code which is simply a proof of concept. Yes it works except that the form designer
           window is updated which we need to prevent. I think on first run of this expert is should
           present a dialogue with a list of the windows and ask the user to select the windows to
           update. It should then automatically do this on start-up however presenting the dialogue can
           always be done from the Help menu to change the options.

**)
Procedure TDGHIDEFontWizard.Execute;
                                          
Begin
  LoadWindowList;
  If TfrmWindowDlg.Execute(FWindowList, FSettings) Then
    Begin
      UpdateWindows;
      SaveWindowList;
    End;
End;

(**

  This is a getter method for the IDString property.

  @precon  None.
  @postcon This method returns a unique ID for the expert.

  @return  a String

**)
Function TDGHIDEFontWizard.GetIDString: String;

Const
  strDGHIDEFontSize = 'DGH.IDE.Font.Size';

Begin
  Result := strDGHIDEFontSize;
End;

(**

  This is a getter method for the MenuText property.

  @precon  None.
  @postcon Returns the name of the menu item under the Help menu in the idea which is used to invoke
           this expert.

  @return  a String

**)
Function TDGHIDEFontWizard.GetMenuText: String;

ResourceString
  strIDEFontSize = 'IDE Fonts...';

Begin
  Result := strIDEFontSize;
End;

(**

  This is a getter method for the Name property.

  @precon  None.
  @postcon Returns the name of the Expert.

  @return  a String

**)
Function TDGHIDEFontWizard.GetName: String;

ResourceString
  strDGHIDEFontSize = 'DGH IDE Font Size';

Begin
  Result := strDGHIDEFontSize;
End;

(**

  This is a getter method for the State property.

  @precon  None.
  @postcon Returns Enabled to signify to the IDE that this expert is enabled.

  @return  a TWizardState

**)
Function TDGHIDEFontWizard.GetState: TWizardState;

Begin
  Result := [wsEnabled];
End;

(**

  This method loads the experts settings from the INI file.

  @precon  None.
  @postcon The experts settings are loaded from the INI file.

**)
Procedure TDGHIDEFontWizard.LoadSettings;

Const
  strDefaultFontName = 'Tahoma';
  iDefaultFontSize = 10;
  iDefaultInterval = 2;
  strDefaultFontColour = 'clWindowText';

Var
  iniFile: TMemIniFile;

Begin
  iniFile := TMemIniFile.Create(FINIFileName);
  Try
    FHasRunBefore := iniFile.ReadBool(strSetupINISection, strHasRunBeforeKey, False);
    FSettings.FParentFont := iniFile.ReadBool(strSetupINISection, strParentFontKey, True);
    FSettings.FFontName := iniFile.ReadString(strSetupINISection, strFontNameKey, strDefaultFontName);
    FSettings.FFontSize := iniFile.ReadInteger(strSetupINISection, strFontSizeKey, iDefaultFontSize);
    FSettings.FUpdateInterval := iniFile.ReadInteger(strSetupINISection, strIntervalKey,
      iDefaultInterval);
    FSettings.FFormFontColour := StringToColor(iniFile.ReadString(strSetupINISection,
      strFormFontColourKey, strDefaultFontColour));
    FSettings.FFontAttrColour := StringToColor(iniFile.ReadString(strSetupINISection,
      strFontAttrColourKey, strDefaultFontColour));
    FSettings.FParentFontColour := StringToColor(iniFile.ReadString(strSetupINISection,
      strParentFontColourKey, strDefaultFontColour));
  Finally
    iniFile.Free;
  End;
End;

(**

  This method loads the list of window open in the IDE and marks them as to whether they are to be
  changed based on the information in the INI file.

  @precon  None.
  @postcon The FWindowList string list is loaded with window in the IDE.

**)
Procedure TDGHIDEFontWizard.LoadWindowList;

Var
  iniFile: TMemIniFile;
  iForm: Integer;
  F: TForm;

Begin
  FWindowList.Clear;
  iniFile := TMemIniFile.Create(FINIFileName);
  Try
    For iForm := 0 To Screen.FormCount - 1 Do
      Begin
        F := Screen.Forms[iForm];
        FWindowList.AddObject(
          Format('%s=%s', [F.Name, F.ClassName]),
          TObject(
            iniFile.ReadBool(strWindowListINISection, Format('%s(%s)', [F.Name, F.ClassName]), False)
          )
        );
      End;
  Finally
    iniFile.Free;
  End;
End;

(**

  This is an Modified event handler for the Wizard interface.

  @precon  None.
  @postcon Does nothing.

  @nocheck EmptyMethod

**)
Procedure TDGHIDEFontWizard.Modified;

Begin //FI:W519
End;

(**

  This method outputs a parent form message is the parent form reference is currently nil.

  @precon  F must be a valid form.
  @postcon The parent form message is output if the references is nil.

  @param   ParentMsg as an IDGHIDEFontCustomMessage as a reference
  @param   F         as a TForm as a constant

**)
Procedure TDGHIDEFontWizard.OutputFormMsg(Var ParentMsg : IDGHIDEFontCustomMessage; Const F : TForm);

ResourceString
  strProcessingForm = 'Processing Form: %s(%s)';

Begin
  If Not Assigned(ParentMsg) Then
    ParentMsg := TDGHIDEFontFunctions.AddMsg(Format(strProcessingForm, [F.Name, F.ClassName]),
       FSettings.FFormFontColour, [], Nil);
End;

(**

  This method saves the experts settings to the INI file.

  @precon  None.
  @postcon The experts settings are saved to the INI file.

**)
Procedure TDGHIDEFontWizard.SaveSettings;

Var
  iniFile: TMemIniFile;

Begin
  iniFile := TMemIniFile.Create(FINIFileName);
  Try
    iniFile.WriteBool(strSetupINISection, strParentFontKey, FSettings.FParentFont);
    iniFile.WriteString(strSetupINISection, strFontNameKey, FSettings.FFontName);
    iniFile.WriteInteger(strSetupINISection, strFontSizeKey, FSettings.FFontSize);
    iniFile.ReadInteger(strSetupINISection, strIntervalKey, FSettings.FUpdateInterval);
    iniFile.WriteString(strSetupINISection, strFormFontColourKey,
      ColorToString(FSettings.FFormFontColour));
    iniFile.WriteString(strSetupINISection, strFontAttrColourKey,
      ColorToString(FSettings.FFontAttrColour));
    iniFile.WriteString(strSetupINISection, strParentFontColourKey,
      ColorToString(FSettings.FParentFontColour));
    iniFile.UpdateFile;
  Finally
    iniFile.Free;
  End;
End;

(**

  This method saves the state of the window list back to the INI file.

  @precon  None.
  @postcon The state of the window list is saved to the INI file.

**)
Procedure TDGHIDEFontWizard.SaveWindowList;

Var
  iniFile: TMemIniFile;
  i: Integer;

Begin
  iniFile := TMemIniFile.Create(FINIFileName);
  Try
    For i := 0 To FWindowList.Count - 1 Do
      iniFile.WriteBool(strWindowListINISection,
        Format('%s(%s)', [
          FWindowList.Names[i],
          FWindowList.ValueFromIndex[i]
        ]), Boolean(FWindowList.Objects[i]));
    iniFile.WriteBool(strSetupINISection, strHasRunBeforeKey, FHasRunBefore);
    iniFile.UpdateFile;
  Finally
    iniFile.Free;
  End;
End;

(**

  This is an on timer event handler for the start timer.

  @precon  None.
  @postcon Waits for the main Application Builder form to appear and then either shows the dialogue for
           a first time user for updates the windows fonts from previous session data.

  @param   Sender as a TObject

**)
Procedure TDGHIDEFontWizard.StartTimerEvent(Sender : TObject);

Const
  strAppBuilderName = 'AppBuilder';

Var
  iForm: Integer;

Begin
  For iForm := 0 To Screen.FormCount - 1 Do
    If CompareText(Screen.Forms[iForm].Name, strAppBuilderName) = 0 Then
      If (Screen.Forms[iForm].Visible) And (Screen.Forms[iForm].CanFocus) Then
        Begin
          If FInterval >= FSettings.FUpdateInterval Then
            Begin
              FStartTimer.Enabled := False;
              If FHasRunBefore Then
                Begin
                  LoadWindowList;
                  UpdateWindows;
                  SaveWindowList;
                End Else
                  Execute;
            End Else
              Inc(FInterval);
        End;
      End;

(**

  This method updates the components on the form to ensure that they have their Parent Font property set 
  to True.

  @precon  F must be a valid instance.
  @postcon All components with the Parent Font property have them set to True if False;

  @param   F         as a TForm as a constant
  @param   ParentMsg as an IDGHIDEFontCustomMessage as a reference

**)
Procedure TDGHIDEFontWizard.UpdateParentFont(Const F : TForm; Var ParentMsg : IDGHIDEFontCustomMessage);

Const
  strParentFontPropName = 'ParentFont';

ResourceString
  strParentFont = '%s(%s).%s(%s).ParentFont = True';

Var
  iComponent: Integer;
  C: TComponent;
  Ctx: TRttiContext;
  T: TRttiType;
  P: TRttiProperty;
  V: TValue;

Begin
  Ctx := TRttiContext.Create;
  For iComponent := 0 To F.ComponentCount - 1 Do
    Begin
      C := F.Components[iComponent];
      T := Ctx.GetType(C.ClassType);
      P := T.GetProperty(strParentFontPropName);
      If Assigned(P) Then
        Begin
          V := P.GetValue(C);
          If Not V.AsBoolean Then
            Begin
              V := True;
              P.SetValue(C, V);
              OutputFormMsg(ParentMsg, F);
              TDGHIDEFontFunctions.AddMsg(
                Format(strParentFont, [
                  F.ClassName,
                  F.Name,
                  C.ClassName,
                  C.Name
                ]),
                FSettings.FParentFontColour, [], ParentMsg.MsgPtr);
            End;
        End;
    End;
End;

(**

  This method iterates through the list of windows in the IDE and checks whether they have been marked
  to have their fonts updated and if so updates them.

  @precon  None.
  @postcon The windows that have been marked for updated have their font name and size changed.

**)
Procedure TDGHIDEFontWizard.UpdateWindows;

ResourceString
  strFontName = '%s(%s).Font.Name = %s';
  strFontSize = '%s(%s).Font.Size = %d';

Var
  iForm : Integer;
  F: TForm;
  iIndex: Integer;
  P: IDGHIDEFontCustomMessage;

Begin
  TDGHIDEFontFunctions.ClearMessages;
  For iForm := 0 To Screen.FormCount - 1 Do
    Begin
      F := Screen.Forms[iForm];
      iIndex := FWindowList.IndexOf(Format('%s=%s', [F.Name, F.ClassName]));
      If Boolean(FWindowList.Objects[iIndex]) Then
        Begin
          P := Nil;
          If CompareText(F.Font.Name, FSettings.FFontName) <> 0 Then
            Begin
              F.Font.Name := FSettings.FFontName;
              OutputFormMsg(P ,F);
              TDGHIDEFontFunctions.AddMsg(Format(strFontName, [F.ClassName, F.Name,
                FSettings.FFontName]), FSettings.FFontAttrColour, [], P.MsgPtr);
            End;
          If F.Font.Size <> FSettings.FFontSize Then
            Begin
              F.Font.Size := FSettings.FFontSize;
              OutputFormMsg(P, F);
              TDGHIDEFontFunctions.AddMsg(Format(strFontSize, [F.ClassName, F.Name,
                FSettings.FFontSize]), FSettings.FFontAttrColour, [], P.MsgPtr);
            End;
          If FSettings.FParentFont Then
            UpdateParentFont(F, P);
        End;
    End;
  FHasRunBefore := True;
End;

End.
