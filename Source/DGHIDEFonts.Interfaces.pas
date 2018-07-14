(**
  
  This module contains a set of interface for the application in order to de-couple the code.

  @Author  David Hoyle
  @Version 1.0
  @Date    01 Jul 2018
  
**)
Unit DGHIDEFonts.Interfaces;

Interface

Uses
  ToolsAPI;

Type
  (** An interface for the custom message. **)
  IDGHIDEFontCustomMessage = Interface(IOTACustomMessage)
  ['{5DE07181-C445-4708-B197-A5055CA2C5AA}']
    Function  GetMsgPtr : Pointer;
    Procedure SetMsgPtr(Const ptrMsg : Pointer);
    (**
      This property gets and sets the messages pointer reference.
      @precon  None.
      @postcon None.
      @return  a Pointer
    **)
    Property MsgPtr : Pointer Read GetMsgPtr Write SetMsgPtr;
  End;

Implementation

End.
