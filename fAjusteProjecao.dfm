object frmAjusteProjecao: TfrmAjusteProjecao
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 85
  ClientWidth = 341
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lbCaptionAjuste: TLabel
    Left = 0
    Top = 0
    Width = 341
    Height = 40
    Align = alClient
    Alignment = taCenter
    Caption = 'Ajuste Superior de Proje'#231#227'o'
    Layout = tlCenter
    ExplicitWidth = 134
    ExplicitHeight = 13
  end
  object tkAjuste: TTrackBar
    Left = 0
    Top = 40
    Width = 341
    Height = 45
    Align = alBottom
    TabOrder = 0
  end
end
