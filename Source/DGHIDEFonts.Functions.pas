(**
  
  This module defines a record to encapsulate general functions for use throughout the application.

  @Author  David Hoyle
  @Version 1.0
  @Date    24 Jun 2018
  
**)
Unit DGHIDEFonts.Functions;

Interface

Type
  (** A record to describe the build information for the expert. **)
  TBuildInfo = Record
    FMajor  : Integer;
    FMinor  : Integer;
    FBugFix : Integer;
    FBuild  : Integer;
  End;

  (** A record to ena=capsulate functions for use throughout the expert. **)
  TDGHIDEFontFunctions = Record
  Strict Private
  Public
    Class Function  BuildNumber(Const strFileName : String) : TBuildInfo; Static;
  End;

Implementation

Uses
  ToolsAPI,
  System.SysUtils,
  WinAPI.Windows,
  DGHIDEFonts.CustomMessage;

(**

  This method returns the build number information for the geivne executable file.

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

End.
