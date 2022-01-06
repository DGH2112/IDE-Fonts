(**
  
  This module contains a set of interface for the application in order to de-couple the code.

  @Author  David Hoyle
  @Version 1.081
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
