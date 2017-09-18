object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'GraviBall 1.0'
  ClientHeight = 717
  ClientWidth = 954
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 8
    Top = 8
    Width = 647
    Height = 600
    OnClick = Image1Click
    OnMouseEnter = Image1MouseEnter
    OnMouseLeave = Image1MouseLeave
    OnMouseMove = Image1MouseMove
  end
  object Label1: TLabel
    Left = 720
    Top = 264
    Width = 130
    Height = 25
    Caption = 'Current Score'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 720
    Top = 304
    Width = 5
    Height = 19
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 720
    Top = 352
    Width = 102
    Height = 25
    Caption = 'High Score'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 720
    Top = 392
    Width = 5
    Height = 19
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 84
    Top = 72
    Width = 495
    Height = 116
    Caption = 'Paused (:P)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -96
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label6: TLabel
    Left = 685
    Top = 80
    Width = 3
    Height = 13
  end
  object Label7: TLabel
    Left = 685
    Top = 112
    Width = 3
    Height = 13
  end
  object Label8: TLabel
    Left = 685
    Top = 144
    Width = 3
    Height = 13
  end
  object Label9: TLabel
    Left = 661
    Top = 208
    Width = 274
    Height = 24
    Caption = 'Click the frame to Pause / Play'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 112
    Top = 634
    Width = 97
    Height = 25
    Caption = 'Start Game'
    TabOrder = 0
    Visible = False
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 144
    Top = 622
    Width = 217
    Height = 75
    Caption = 'Stop and Reset Game'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 504
    Top = 634
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 2
    OnClick = Button3Click
  end
  object RadioButton1: TRadioButton
    Left = 737
    Top = 472
    Width = 113
    Height = 17
    Caption = 'High diff'
    TabOrder = 3
    OnClick = RadioButton1Click
  end
  object RadioButton2: TRadioButton
    Left = 737
    Top = 520
    Width = 113
    Height = 17
    Caption = 'medium'
    TabOrder = 4
    OnClick = RadioButton2Click
  end
  object RadioButton3: TRadioButton
    Left = 737
    Top = 568
    Width = 113
    Height = 17
    Caption = 'easy peasy'
    Checked = True
    TabOrder = 5
    TabStop = True
    OnClick = RadioButton3Click
  end
  object CheckBox1: TCheckBox
    Left = 685
    Top = 48
    Width = 137
    Height = 17
    Caption = 'Show Dev Stats'
    TabOrder = 6
    Visible = False
  end
  object CheckBox2: TCheckBox
    Left = 677
    Top = 435
    Width = 244
    Height = 17
    Caption = 'Change speed with difficulty (not value of G)'
    TabOrder = 7
    Visible = False
  end
  object Timer1: TTimer
    Interval = 50
    OnTimer = Timer1Timer
    Left = 680
    Top = 560
  end
end
