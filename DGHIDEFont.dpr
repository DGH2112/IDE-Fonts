(**
  
  This module defines a DLL Expert for the RAD Studio IDE which allows the user to change the Font Name
  and Font Size of the forms in the IDE.

  @Author  David Hoyle
  @Version 1.0
  @Date    08 Jun 2018

  @nocheck EmptyBeginEnd
  
**)
Library DGHIDEFont;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$R 'DGHIDEFont.ITHVerInfo.res' 'DGHIDEFont.ITHVerInfo.RC'}
{$R 'DGHIDEFontBitMaps.res' 'DGHIDEFontBitMaps.rc'}

uses
  System.SysUtils,
  System.Classes,
  DGHIDEFont.Wizard in 'Source\DGHIDEFont.Wizard.pas',
  DGHIDEFont.Functions in 'Source\DGHIDEFont.Functions.pas',
  DGHIDEFont.SplashScreen in 'Source\DGHIDEFont.SplashScreen.pas',
  DGHIDEFont.WindowDlg in 'Source\DGHIDEFont.WindowDlg.pas' {frmWindowDlg};

{$R *.res}

{$INCLUDE 'Source\CompilerDefinitions.inc'}
{$INCLUDE 'Source\LibrarySuffixes.inc'}

Begin

End.
