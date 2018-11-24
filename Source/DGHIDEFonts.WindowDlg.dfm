object frmWindowDlg: TfrmWindowDlg
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSizeToolWin
  Caption = 'IDE Window List'
  ClientHeight = 669
  ClientWidth = 464
  Color = clBtnFace
  Constraints.MinHeight = 640
  Constraints.MinWidth = 480
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  object pnlFudgePanel: TPanel
    Left = 0
    Top = 0
    Width = 464
    Height = 669
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 152
    ExplicitTop = 336
    ExplicitWidth = 185
    ExplicitHeight = 41
    DesignSize = (
      464
      669)
    object lblParentFontColour: TLabel
      Left = 8
      Top = 645
      Width = 107
      Height = 16
      Anchors = [akLeft, akBottom]
      Caption = '&Parent Font Colour'
    end
    object lblFormFontColour: TLabel
      Left = 8
      Top = 589
      Width = 100
      Height = 16
      Anchors = [akLeft, akBottom]
      Caption = '&Form Font Colour'
    end
    object lblFontAttrColour: TLabel
      Left = 8
      Top = 617
      Width = 119
      Height = 16
      Anchors = [akLeft, akBottom]
      Caption = 'Font &Attribute Colour'
    end
    object lblDelayInterval: TLabel
      Left = 8
      Top = 556
      Width = 177
      Height = 16
      Anchors = [akLeft, akBottom]
      AutoSize = False
      Caption = 'Delay &Interval after Visible'
      FocusControl = edtDelayInterval
    end
    object Label1: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 457
      Height = 54
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 
        'Select the windows from the list below you wish to update their ' +
        'font name and size. Please be aware that this list includes the ' +
        'form designers for any forms you are currently have open.'
      WordWrap = True
    end
    object udDelayInterval: TUpDown
      Left = 375
      Top = 553
      Width = 16
      Height = 24
      Anchors = [akRight, akBottom]
      Associate = edtDelayInterval
      Max = 60
      Position = 8
      TabOrder = 6
    end
    object udFontSize: TUpDown
      Left = 375
      Top = 523
      Width = 16
      Height = 24
      Anchors = [akRight, akBottom]
      Associate = edtFontSize
      Min = 8
      Max = 18
      Position = 8
      TabOrder = 4
    end
    object lvWindowList: TListView
      AlignWithMargins = True
      Left = 8
      Top = 63
      Width = 448
      Height = 431
      Anchors = [akLeft, akTop, akRight, akBottom]
      Checkboxes = True
      Columns = <
        item
          AutoSize = True
          Caption = 'Name'
        end
        item
          AutoSize = True
          Caption = 'Class Name'
        end>
      GridLines = True
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
    end
    object edtFontSize: TEdit
      Left = 191
      Top = 523
      Width = 184
      Height = 24
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 3
      Text = '8'
    end
    object edtDelayInterval: TEdit
      Left = 191
      Top = 553
      Width = 184
      Height = 24
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 5
      Text = '8'
    end
    object chkParentFont: TCheckBox
      Left = 8
      Top = 500
      Width = 448
      Height = 17
      Anchors = [akLeft, akRight, akBottom]
      Caption = 'Update the Form Component'#39's ParentFont to True'
      TabOrder = 1
    end
    object cbxParentFontColour: TColorBox
      Left = 191
      Top = 639
      Width = 184
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames, cbCustomColors]
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 9
    end
    object cbxFormFontColour: TColorBox
      Left = 191
      Top = 583
      Width = 184
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames, cbCustomColors]
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 7
    end
    object cbxFontName: TComboBox
      Left = 8
      Top = 523
      Width = 177
      Height = 24
      Style = csDropDownList
      Anchors = [akLeft, akBottom]
      TabOrder = 2
    end
    object cbxFontAttrColour: TColorBox
      Left = 191
      Top = 611
      Width = 184
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames, cbCustomColors]
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 8
    end
    object btnOK: TButton
      Left = 381
      Top = 605
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Default = True
      ImageIndex = 1
      ImageMargins.Left = 5
      Images = ilButtonImages
      ModalResult = 1
      TabOrder = 10
    end
    object btnCancel: TButton
      Left = 381
      Top = 636
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Cancel'
      ImageIndex = 0
      ImageMargins.Left = 5
      Images = ilButtonImages
      ModalResult = 2
      TabOrder = 11
    end
  end
  object ilButtonImages: TImageList
    Left = 152
    Top = 168
    Bitmap = {
      494C010102000800040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000080000000800080808000000000000000000000000000000000000000
      00000000FF008080800000000000000000000000000000000000000000000000
      0000000000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000080000000800000008000808080000000000000000000000000000000
      FF00000080000000800080808000000000000000000000000000000000000000
      0000800000000080000000800000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000800000008000000080000000800080808000000000000000FF000000
      8000000080000000800000008000808080000000000000000000000000008000
      0000008000000080000000800000008000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000800000008000000080000000800080808000000080000000
      8000000080000000800000008000808080000000000000000000800000000080
      0000008000000080000000800000008000000080000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000008000000080000000800000008000000080000000
      8000000080000000800080808000000000000000000080000000008000000080
      00000080000000FF000000800000008000000080000000800000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000080000000800000008000000080000000
      8000000080008080800000000000000000000000000000800000008000000080
      000000FF00000000000000FF0000008000000080000000800000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080000000800000008000000080000000
      8000808080000000000000000000000000000000000000FF00000080000000FF
      000000000000000000000000000000FF00000080000000800000008000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000800000008000000080000000
      800080808000000000000000000000000000000000000000000000FF00000000
      00000000000000000000000000000000000000FF000000800000008000000080
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000080000000800000008000000080000000
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF0000008000000080
      0000008000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000008000000080000000800080808000000080000000
      8000000080008080800000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF00000080
      0000008000000080000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF0000008000000080000000800080808000000000000000FF000000
      8000000080000000800080808000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      0000008000000080000000800000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000800000008000808080000000000000000000000000000000
      FF00000080000000800000008000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF00000080000000800000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000008000000000000000000000000000000000000000
      00000000FF000000800000008000000080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000800000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF00000080000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF0000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00E1F3F9FF00000000E0E1F0FF00000000
      E040E07F00000000F000C03F00000000F801801F00000000FC03841F00000000
      FE078E0F00000000FE07DF0700000000FC07FF8300000000F803FFC100000000
      F041FFE000000000F0E0FFF000000000F9F0FFF800000000FFF8FFFC00000000
      FFFFFFFE00000000FFFFFFFF0000000000000000000000000000000000000000
      000000000000}
  end
end
