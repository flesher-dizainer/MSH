object FormSettings: TFormSettings
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 395
  ClientWidth = 389
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    389
    395)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 344
    Width = 389
    Height = 51
    Align = alBottom
    BevelEdges = [beTop]
    BevelKind = bkTile
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      389
      49)
    object btnOK: TButton
      Left = 51
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1050
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 176
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnApply: TButton
      Left = 303
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
      TabOrder = 2
      OnClick = btnApplyClick
    end
  end
  object RzPageControl1: TRzPageControl
    Left = 8
    Top = 8
    Width = 373
    Height = 330
    Hint = ''
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    BoldCurrentTab = True
    Color = 16119543
    FlatColor = 10263441
    ParentColor = False
    ShowFocusRect = False
    TabColors.HighlightBar = 1350640
    TabIndex = 0
    TabOrder = 1
    TabStyle = tsRoundCorners
    FixedDimension = 19
    object TabSheet1: TRzTabSheet
      Color = 16119543
      Caption = #1055#1086#1076#1082#1083#1102#1095#1077#1085#1080#1077
      object RzGroupBox1: TRzGroupBox
        Left = 16
        Top = 3
        Width = 337
        Height = 70
        Caption = ' COM '#1087#1086#1088#1090' '
        TabOrder = 0
        object Label1: TLabel
          Left = 16
          Top = 16
          Width = 29
          Height = 13
          Caption = #1055#1086#1088#1090':'
        end
        object cbPortList: TComboBox
          Left = 16
          Top = 35
          Width = 145
          Height = 21
          Style = csDropDownList
          TabOrder = 0
        end
      end
      object RzGroupBox2: TRzGroupBox
        Left = 16
        Top = 79
        Width = 337
        Height = 74
        Caption = ' '#1057#1082#1086#1088#1086#1089#1090#1100' '#1080' '#1090#1072#1081#1084#1072#1091#1090#1099' '
        TabOrder = 1
        object Label2: TLabel
          Left = 16
          Top = 16
          Width = 132
          Height = 13
          Caption = #1057#1082#1086#1088#1086#1089#1090#1100' '#1080#1085#1080#1094#1080#1072#1083#1080#1079#1072#1094#1080#1080':'
        end
        object Label4: TLabel
          Left = 179
          Top = 16
          Width = 144
          Height = 13
          Caption = #1048#1085#1090#1077#1088#1074#1072#1083' '#1084#1077#1078#1076#1091' '#1079#1072#1087#1088#1086#1089#1072#1084#1080':'
        end
        object Label5: TLabel
          Left = 232
          Top = 38
          Width = 27
          Height = 13
          Caption = #1084#1089#1077#1082'.'
        end
        object cbBaudRate: TComboBox
          Left = 16
          Top = 35
          Width = 145
          Height = 21
          Style = csDropDownList
          ItemIndex = 0
          TabOrder = 0
          Text = '10400'
          Items.Strings = (
            '10400'
            '38400'
            '57600')
        end
        object edDelay: TRzSpinEdit
          Left = 179
          Top = 35
          Width = 47
          Height = 21
          Max = 1000.000000000000000000
          Min = 10.000000000000000000
          Value = 148.000000000000000000
          TabOrder = 1
        end
      end
      object RzGroupBox6: TRzGroupBox
        Left = 16
        Top = 159
        Width = 337
        Height = 40
        Caption = #1064#1044#1050
        TabOrder = 2
        object Label3: TLabel
          Left = 16
          Top = 16
          Width = 25
          Height = 13
          Caption = 'COM'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label11: TLabel
          Left = 179
          Top = 16
          Width = 46
          Height = 13
          Caption = #1058#1080#1087' '#1064#1044#1050
        end
        object CbPortLC: TComboBox
          Left = 47
          Top = 12
          Width = 71
          Height = 21
          TabOrder = 0
        end
        object CBLamda: TComboBox
          Left = 231
          Top = 19
          Width = 82
          Height = 21
          ImeMode = imHira
          TabOrder = 1
          Text = 'LC/LM-1/2'
          Items.Strings = (
            'LC/LM-1/2'
            'AEM'
            'VEMS')
        end
      end
      object RzGroupBox3: TRzGroupBox
        Left = 16
        Top = 205
        Width = 337
        Height = 96
        Caption = #1060#1072#1079#1072' '#1074#1087#1088#1099#1089#1082#1072
        TabOrder = 3
        object Label6: TLabel
          Left = 26
          Top = 39
          Width = 25
          Height = 13
          Caption = 'INOP'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label7: TLabel
          Left = 197
          Top = 39
          Width = 23
          Height = 13
          Caption = 'INCL'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label8: TLabel
          Left = 26
          Top = 72
          Width = 26
          Height = 13
          Caption = 'EXOP'
          OnClick = Label8Click
        end
        object Label9: TLabel
          Left = 196
          Top = 72
          Width = 24
          Height = 13
          Caption = 'EXCL'
          OnClick = Label8Click
        end
        object RadioButton1: TRadioButton
          Left = 16
          Top = 16
          Width = 132
          Height = 17
          Caption = #1042#1087#1088#1099#1089#1082' '#1074' '#1079#1072#1082#1088#1099#1090#1099#1081
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object RadioButton2: TRadioButton
          Left = 197
          Top = 16
          Width = 137
          Height = 17
          Caption = #1042#1087#1088#1099#1089#1082' '#1074' '#1086#1090#1082#1088#1099#1090#1099#1081
          TabOrder = 1
        end
        object RzINOP: TRzSpinEdit
          Left = 57
          Top = 39
          Width = 47
          Height = 21
          Hint = #1059#1075#1086#1083' '#1086#1090#1082#1088#1099#1090#1080#1103' '#1074#1087#1091#1089#1082#1072'(360 - '#1091#1075#1086#1083' '#1086#1090#1082#1088#1099#1090#1080#1103' '#1076#1086' '#1074#1084#1090')'
          Max = 380.000000000000000000
          Min = 270.000000000000000000
          Value = 360.000000000000000000
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          TextHint = #1059#1075#1086#1083' '#1086#1090#1082#1088#1099#1090#1080#1103' '#1074#1087#1091#1089#1082#1072'(360 - '#1091#1075#1086#1083' '#1086#1090#1082#1088#1099#1090#1080#1103' '#1076#1086' '#1074#1084#1090')'
          TextHintVisibleOnFocus = True
        end
        object RzINCL: TRzSpinEdit
          Left = 226
          Top = 39
          Width = 47
          Height = 21
          Hint = #1047#1072#1082#1088#1099#1090#1080#1077' '#1074#1087#1091#1089#1082#1072' '#1087#1086#1089#1083#1077' '#1053#1052#1058'(540 + '#1091#1075#1086#1083' '#1079#1072#1082#1088#1099#1090#1080#1103' '#1087#1086#1089#1083#1077' '#1053#1052#1058')'
          Max = 640.000000000000000000
          Min = 500.000000000000000000
          Value = 540.000000000000000000
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          TextHint = #1047#1072#1082#1088#1099#1090#1080#1077' '#1074#1087#1091#1089#1082#1072' '#1087#1086#1089#1083#1077' '#1053#1052#1058'(540 + '#1091#1075#1086#1083' '#1079#1072#1082#1088#1099#1090#1080#1103' '#1087#1086#1089#1083#1077' '#1053#1052#1058')'
        end
        object RzEXOP: TRzSpinEdit
          Left = 58
          Top = 66
          Width = 47
          Height = 21
          Hint = #1059#1075#1086#1083' '#1086#1090#1082#1088#1099#1090#1080#1103' '#1074#1099#1087#1091#1089#1082#1072' '#1076#1086' '#1053#1052#1058'(180 - '#1091#1075#1086#1083' '#1086#1090#1082#1088#1099#1090#1080#1103' '#1076#1086' '#1053#1052#1058')'
          Max = 200.000000000000000000
          Min = 90.000000000000000000
          Value = 180.000000000000000000
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          TextHint = #1059#1075#1086#1083' '#1086#1090#1082#1088#1099#1090#1080#1103' '#1074#1099#1087#1091#1089#1082#1072' '#1076#1086' '#1053#1052#1058'(540 - '#1091#1075#1086#1083' '#1086#1090#1082#1088#1099#1090#1080#1103' '#1076#1086' '#1053#1052#1058')'
        end
        object RzEXCL: TRzSpinEdit
          Left = 226
          Top = 66
          Width = 47
          Height = 21
          Hint = #1047#1072#1082#1088#1099#1090#1080#1077' '#1074#1099#1087#1091#1089#1082#1072'(360 + '#1091#1075#1086#1083' '#1079#1072#1082#1088#1099#1090#1080#1103' '#1087#1086#1089#1083#1077' '#1074#1084#1090')'
          Max = 420.000000000000000000
          Min = 300.000000000000000000
          Value = 360.000000000000000000
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          TextHint = #1047#1072#1082#1088#1099#1090#1080#1077' '#1074#1099#1087#1091#1089#1082#1072'(360 + '#1091#1075#1086#1083' '#1079#1072#1082#1088#1099#1090#1080#1103' '#1087#1086#1089#1083#1077' '#1074#1084#1090')'
        end
      end
    end
  end
end
