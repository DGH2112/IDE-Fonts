(**
  
  This module defines a DLL Expert for the RAD Studio IDE which allows the user to change the Font Name
  and Font Size of the forms in the IDE.

  @Author  David Hoyle
  @Version 1.101
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

  @nocheck EmptyBeginEnd
  
**)
Library DGHIDEFonts;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$R 'DGHIDEFonts.ITHVerInfo.res' 'DGHIDEFonts.ITHVerInfo.RC'}
{$R 'DGHIDEFontsBitMaps.res' 'DGHIDEFontsBitMaps.rc'}

uses
  SysUtils,
  Classes,
  DGHIDEFonts.Wizard in 'Source\DGHIDEFonts.Wizard.pas',
  DGHIDEFonts.Functions in 'Source\DGHIDEFonts.Functions.pas',
  DGHIDEFonts.SplashScreen in 'Source\DGHIDEFonts.SplashScreen.pas',
  DGHIDEFonts.WindowDlg in 'Source\DGHIDEFonts.WindowDlg.pas' {frmWindowDlg},
  DGHIDEFonts.CustomMessage in 'Source\DGHIDEFonts.CustomMessage.pas',
  DGHIDEFonts.Interfaces in 'Source\DGHIDEFonts.Interfaces.pas';

{$R *.res}

{$INCLUDE 'Source\CompilerDefinitions.inc'}
{$INCLUDE 'Source\LibrarySuffixes.inc'}

Begin

End.
