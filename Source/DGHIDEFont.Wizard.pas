(**
  
  This module defines the main wizxard interface for this RAD Studio IDE expert.

  @Author  David Hoyle
  @Version 1.0
  @Date    08 Jun 2018
  
**)
Unit DGHIDEFont.Wizard;

Interface

Uses
  ToolsAPI, DGHIDEFont.Functions;

Type
  (** A class which implements the IOTAWizard and ITAMenuWizard interfaces for the RAD Studio IDE
      expert. **)
  TDGHIDEFontSizeWizard = Class(TInterfacedObject, IOTAWizard, IOTAMenuWizard)
  Strict Private
  Strict Protected
    // IOTAWizard
    Procedure Execute;
    Function  GetIDString: String;
    Function  GetName: String;
    Function  GetState: TWizardState;
    Procedure AfterSave;
    Procedure BeforeSave;
    Procedure Destroyed;
    Procedure Modified;
    // IOTAMenuWizard
    Function  GetMenuText: String;
  Public
    Constructor Create;
  End;

  Function InitWizard(Const BorlandIDEServices : IBorlandIDEServices; RegisterProc : TWizardRegisterProc;
    var Terminate: TWizardTerminateProc) : Boolean; StdCall;

Exports
  InitWizard Name WizardEntryPoint;
  
Implementation

Uses
  System.SysUtils,
  System.Classes,
  System.RTTI,
  VCL.Controls,
  VCL.Forms,
  VCL.Dialogs, DGHIDEFont.SplashScreen;

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
  var Terminate: TWizardTerminateProc) : Boolean; StdCall;

Begin
  Result := Assigned(BorlandIDEServices);
  If Result Then
    RegisterProc(TDGHIDEFontSizeWizard.Create);
End;

(**

  This is an AfterSave event handler for the Wizard interface.

  @precon  None.
  @postcon Does nothing.

  @nocheck EmptyMethod

**)
Procedure TDGHIDEFontSizeWizard.AfterSave;

Begin
End;

(**

  This is an BeforeSave event handler for the Wizard interface.

  @precon  None.
  @postcon Does nothing.

  @nocheck EmptyMethod

**)
Procedure TDGHIDEFontSizeWizard.BeforeSave;

Begin
End;

(**

  A constructor for the TDGHIDEFont class.

  @precon  None.
  @postcon Adds a splash screen to the IDE.

**)
Constructor TDGHIDEFontSizeWizard.Create;

Begin
  TDGHIDEFontSplashScreen.AddSplashScreen;
End;

(**

  This is an Destroyed event handler for the Wizard interface.

  @precon  None.
  @postcon Does nothing.

  @nocheck EmptyMethod

**)
Procedure TDGHIDEFontSizeWizard.Destroyed;

Begin
End;

(**

  This method invokes the experts functionality to change the font name and size of the IDEs windows.

  @precon  None.
  @postcon Contains code which is simply a proof of concept. Yes it works except that the form designer
           window is updated which we need to prevent. I think on first run of this expert is should
           present a dialogue with a list of the windows and ask the user to select the windows to
           update. It should then automatically do this on startup however presenting the dialogue can
           always be done from the Help menu to change the options.

**)
Procedure TDGHIDEFontSizeWizard.Execute;

ResourceString
  strProcessingForm = 'Processing Form: %s(%s)';

Const
  strDefaultFontName = 'Tahoma';
  iDefaultFontSize = 10;
  strParentFontPropName = 'ParentFont';

Var
  iForm : Integer;
  F: TForm;
  iComponent: Integer;
  C: TComponent;
  Ctx: TRttiContext;
  T: TRttiType;
  P: TRttiProperty;
  V: TValue;
  
Begin
  For iForm := 0 To Screen.FormCount - 1 Do
    Begin
      F := Screen.Forms[iForm];
      //: @bug Need to omit to IDE Form Design from the list!
      TDGHIDEFontFunctions.OutputMsg(Format(strProcessingForm, [F.Name, F.ClassName]));
      F.Font.Name := strDefaultFontName;
      F.Font.Size := iDefaultFontSize;
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
                End;
            End;
        End;
    End;
End;

(**

  This is a getter method for the IDString property.

  @precon  None.
  @postcon This method returns a unique ID for the expert.

  @return  a String

**)
Function TDGHIDEFontSizeWizard.GetIDString: String;

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
Function TDGHIDEFontSizeWizard.GetMenuText: String;

ResourceString
  strIDEFontSize = 'IDE Font Size';

Begin
  Result := strIDEFontSize;
End;

(**

  This is a getter method for the Name property.

  @precon  None.
  @postcon Returns the name of the Expert.

  @return  a String

**)
Function TDGHIDEFontSizeWizard.GetName: String;

ResourceString
  strDGHIDEFontSize = 'DGH IDE Font Size';

Begin
  Result := strDGHIDEFontSize;
End;

(**

  This is a getter method for the State property.

  @precon  None.
  @postcon Returns wsEnabled to signify to the IDE that this expert is enabled.

  @return  a TWizardState

**)
Function TDGHIDEFontSizeWizard.GetState: TWizardState;

Begin
  Result := [wsEnabled];
End;

(**

  This is an Modified event handler for the Wizard interface.

  @precon  None.
  @postcon Does nothing.

  @nocheck EmptyMethod

**)
Procedure TDGHIDEFontSizeWizard.Modified;

Begin
End;

End.
