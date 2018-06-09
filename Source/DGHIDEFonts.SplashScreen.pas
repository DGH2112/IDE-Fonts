(**
  
  This module contains the code for adding a splash screen entry to the IDE on startup.

  @Author  David Hoyle
  @Version 1.0
  @Date    09 Jun 2018
  
**)
Unit DGHIDEFonts.SplashScreen;

Interface

Type
  (** A record to encapsulate the splasn screen functionality. **)
  TDGHIDEFontSplashScreen = Record
  Strict Private
  Public
    Class Procedure AddSplashScreen; Static;
  End;
  
Implementation

Uses
  ToolsAPI,
  System.SysUtils,
  VCL.Forms,
  WinAPI.Windows,
  DGHIDEFonts.Functions;

(**

  This method adds a splash screen to the IDE startup screen.

  @precon  None.
  @postcon The splash screen is added.

**)
Class Procedure TDGHIDEFontSplashScreen.AddSplashScreen;

ResourceString
  strSplashScreenName = 'DGH IDE Fonts %d.%d%s for %s';
  {$IFDEF DEBUG}
  strSplashScreenBuild = 'Freeware by David Hoyle (DEBUG Build %d.%d.%d.%d)';
  {$ELSE}
  strSplashScreenBuild = 'Freeware by David Hoyle (Build %d.%d.%d.%d)';
  {$ENDIF}

Const
  strRevisions = ' abcedfghijklmnopqrstuvwxyz';
  strDGHIDEFontSplashScreen = 'DGHIDEFontSplashScreen24x24';

Var
  SSS : IOTASplashScreenServices;
  bmSplashScreen : HBITMAP;
  BuildInfo : TBuildInfo;
  strModuleName: String;
  iSize: Cardinal;
  
Begin
  bmSplashScreen := LoadBitmap(hInstance, strDGHIDEFontSplashScreen);
  SetLength(strModuleName, MAX_PATH);
  iSize := GetModuleFileName(hInstance, PChar(strModuleName), MAX_PATH);
  SetLength(strModuleName, iSize);
  BuildInfo := TDGHIDEFontFunctions.BuildNumber(strModuleName);
  If Supports(SplashScreenServices, IOTASplashScreenServices, SSS) Then
    Begin
      SSS.AddPluginBitmap(
        Format(strSplashScreenName, [
          BuildInfo.FMajor,
          BuildInfo.FMinor,
          Copy(strRevisions, Succ(BuildInfo.FBugfix), 1),
          Application.Title
        ]),
        bmSplashScreen,
        {$IFDEF DEBUG} False {$ELSE} True {$ENDIF},
        Format(strSplashScreenBuild, [
          BuildInfo.FMajor,
          BuildInfo.FMinor,
          BuildInfo.FBugfix,
          BuildInfo.FBuild
        ])
      );
    End;
End;

End.
