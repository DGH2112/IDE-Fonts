(**
  
  This module defines a record to encapsulate general functions for use throughout the application.

  @Author  David Hoyle
  @Version 1.0
  @Date    08 Jun 2018
  
**)
Unit DGHIDEFont.Functions;

Interface

Type
  (** A record to ena=capsulate functions for use throughout the expert. **)
  TDGHIDEFontFunctions = Record
  Strict Private
  Public
    Class Procedure OutputMsg(Const strMsg : String); Static;
  End;

Implementation

Uses
  ToolsAPI,
  System.SysUtils;

(**

  This method outputs a message to the IDEs message window in a specific group tab.

  @precon  None.
  @postcon The messawge geiven is output to the message window.

  @param   strMsg as a String as a constant

**)
Class Procedure TDGHIDEFontFunctions.OutputMsg(Const strMsg: String);

ResourceString
  strDGHIDEFontSizeMessages = 'DGH IDE Font Size Messages';

Var
  MS : IOTAMessageServices;
  G: IOTAMessageGroup;
  
Begin
  If Supports(BorlandIDEServices, IOTAMessageServices, MS) Then
    Begin
      G := MS.AddMessageGroup(strDGHIDEFontSizeMessages);
      MS.ShowMessageView(G);
      MS.AddTitleMessage(strMsg, G);
    End;
End;

End.
