(**
  
  This module defines a record to encapsulate general functions for use throughout the application.

  @Author  David Hoyle
  @Version 1.001
  @Date    06 Jan 2022
  
**)
Unit DGHIDEFonts.Functions;

Interface

Uses
  DGHIDEFonts.Interfaces,
  Graphics;

Type
  (** A record to describe the build information for the expert. **)
  TBuildInfo = Record
    FMajor  : Integer;
    FMinor  : Integer;
    FBugFix : Integer;
    FBuild  : Integer;
  End;

  (** A record to encapsulate functions for use throughout the expert. **)
  TDGHIDEFontFunctions = Record
  Strict Private
  Public
    Class Function  BuildNumber(Const strFileName : String) : TBuildInfo; Static;
    Class Function AddMsg(Const strMsg : String; Const iColour : TColor;
      Const setStyles : TFontStyles = []; Const ptrParentMsg : Pointer = Nil) : IDGHIDEFontCustomMessage;
      Static;
    Class Procedure ClearMessages(); Static;
  End;

Implementation

Uses
  ToolsAPI,
  SysUtils,
  Windows,
  DGHIDEFonts.CustomMessage;

ResourceString
  (** A resource string to definer the name of the message group. **)
  strDGHIDEFontMessages = 'DGH IDE Font Messages';

(**

  This method creates a custom message adds it to the IDe message view.

  @precon  If ptrParentMsg is specified it must pointer to a valid message instance.
  @postcon Create a custom message with the option parent as a message.

  @param   strMsg       as a String as a constant
  @param   iColour      as a TColor as a constant
  @param   setStyles    as a TFontStyles as a constant
  @param   ptrParentMsg as a Pointer as a constant
  @return  an IDGHIDEFontCustomMessage

**)
Class Function TDGHIDEFontFunctions.AddMsg(Const strMsg : String; Const iColour : TColor;
  Const setStyles : TFontStyles = []; Const ptrParentMsg : Pointer = Nil) : IDGHIDEFontCustomMessage;

Var
  MS : IOTAMessageServices;
  M : IDGHIDEFontCustomMessage;
  G: IOTAMessageGroup;

Begin
  Result := Nil;
  If Supports(BorlandIDEServices, IOTAMessageServices, MS) Then
    Begin
      M := TDGHIDEFontCustomMessage.Create(strMsg, iColour, setStyles);
      Result := M;
      If Not Assigned(ptrParentMsg) Then
        Begin
          G := MS.AddMessageGroup(strDGHIDEFontMessages);
          Result.MsgPtr := MS.AddCustomMessagePtr(M, G);
        End Else
          MS.AddCustomMessage(M, ptrParentMsg);
    End;
End;

(**

  This method returns the build number information for the given executable file.

  @precon  None.
  @postcon The build number information for the executable is returned.

  @param   strFileName as a String as a constant
  @return  a TBuildInfo

**)
Class Function TDGHIDEFontFunctions.BuildNumber(Const strFileName: String): TBuildInfo;

Const
  iShiftRight16 = 16;
  iWordMask = $FFFF;

Var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;

Begin
  Result.FMajor := 0;
  Result.FMinor := 0;
  Result.FBugFix := 0;
  Result.FBuild := 0;
  VerInfoSize := GetFileVersionInfoSize(PChar(strFileName), Dummy);
  If VerInfoSize <> 0 Then
    Begin
      GetMem(VerInfo, VerInfoSize);
      Try
        GetFileVersionInfo(PChar(strFileName), 0, VerInfoSize, VerInfo);
        VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
        Result.FMajor := VerValue^.dwFileVersionMS Shr iShiftRight16;
        Result.FMinor := VerValue^.dwFileVersionMS And iWordMask;
        Result.FBugFix := VerValue^.dwFileVersionLS Shr iShiftRight16;
        Result.FBuild := VerValue^.dwFileVersionLS And iWordMask;
      Finally
        FreeMem(VerInfo, VerInfoSize);
      End;
    End;
End;

(**

  This method clears the DGH IDE Font message window.

  @precon  None.
  @postcon The DGH IDE Font Message window is cleared of all messages.

**)
Class Procedure TDGHIDEFontFunctions.ClearMessages;

Var
  MS : IOTAMessageServices;
  G: IOTAMessageGroup;

Begin
  If Supports(BorlandIDEServices, IOTAMessageServices, MS) Then
    Begin
      G := MS.GetGroup(strDGHIDEFontMessages);
      If Assigned(G) Then
        MS.ClearMessageGroup(G);
    End;
End;

End.
