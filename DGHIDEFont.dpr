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

uses
  System.SysUtils,
  System.Classes,
  DGHIDEFontSize.Wizard in 'Source\DGHIDEFontSize.Wizard.pas',
  DGHIDEFontSize.Functions in 'Source\DGHIDEFontSize.Functions.pas';

{$R *.res}

{$INCLUDE 'Source\CompilerDefinitions.inc'}
{$INCLUDE 'Source\LibrarySuffixes.inc'}

Begin

End.
