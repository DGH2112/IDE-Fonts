(**
  
  This module contains the code for adding a splash screen entry to the IDE on start-up.

  @Author  David Hoyle
  @Version 1.188
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
Unit DGHIDEFonts.SplashScreen;

Interface

Type
  (** A record to encapsulate the splash screen functionality. **)
  TDGHIDEFontSplashScreen = Record
  Strict Private
  Public
    Class Procedure AddSplashScreen; Static;
  End;
  
Implementation

{$INCLUDE CompilerDefinitions.inc}

Uses
  ToolsAPI,
  SysUtils,
  Forms,
  {$IFDEF RS110}
  Graphics,
  {$ENDIF RS110}
  Windows,
  DGHIDEFonts.Functions;

(**

  This method adds a splash screen to the IDE start-up screen.

  @precon  None.
  @postcon The splash screen is added.

**)
Class Procedure TDGHIDEFontSplashScreen.AddSplashScreen;

ResourceString
  strSplashScreenName = 'DGH IDE Fonts %d.%d%s for %s';
  {$IFDEF DEBUG}
  strSplashScreenBuild = 'David Hoyle (c) 2022 License GNU GPL3 (DEBUG Build %d.%d.%d.%d)';
  {$ELSE}
  strSplashScreenBuild = 'David Hoyle (c) 2022 License GNU GPL3 (Build %d.%d.%d.%d)';
  {$ENDIF}

Const
  strRevisions = ' abcedfghijklmnopqrstuvwxyz';
  strDGHIDEFontSplashScreen = 'DGHIDEFontSplashScreen24x24';

Var
  SSS : IOTASplashScreenServices;
  bmSplashScreen : {$IFDEF RS110} Graphics.TBitMap {$ELSE} HBITMAP {$ENDIF RS110};
  BuildInfo : TBuildInfo;
  strModuleName: String;
  iSize: Cardinal;
  
Begin
  SetLength(strModuleName, MAX_PATH);
  iSize := GetModuleFileName(hInstance, PChar(strModuleName), MAX_PATH);
  SetLength(strModuleName, iSize);
  BuildInfo := TDGHIDEFontFunctions.BuildNumber(strModuleName);
  If Supports(SplashScreenServices, IOTASplashScreenServices, SSS) Then
    Begin
      {$IFDEF RS110}
      bmSplashScreen := Graphics.TBitMap.Create;
      Try
        bmSplashScreen.LoadFromResourceName(hInstance, strDGHIDEFontSplashScreen);
        SSS.AddPluginBitmap(
          Format(strSplashScreenName, [BuildInfo.FMajor, BuildInfo.FMinor, Copy(strRevisions, Succ(BuildInfo.FBugfix), 1), Application.Title]),
          [bmSplashScreen],
          {$IFDEF DEBUG} True {$ELSE} False {$ENDIF},
          Format(strSplashScreenBuild, [BuildInfo.FMajor, BuildInfo.FMinor, BuildInfo.FBugfix, BuildInfo.FBuild])
        );
      Finally
        bmSplashScreen.Free;
      End;
      {$ELSE}
      bmSplashScreen := LoadBitmap(hInstance, strDGHIDEFontSplashScreen);
      SSS.AddPluginBitmap(
        Format(strSplashScreenName, [BuildInfo.FMajor, BuildInfo.FMinor, Copy(strRevisions, Succ(BuildInfo.FBugfix), 1), Application.Title]),
        bmSplashScreen,
        {$IFDEF DEBUG} True {$ELSE} False {$ENDIF},
        Format(strSplashScreenBuild, [BuildInfo.FMajor, BuildInfo.FMinor, BuildInfo.FBugfix, BuildInfo.FBuild])
      );
      {$ENDIF RS110}
    End;
End;

End.
