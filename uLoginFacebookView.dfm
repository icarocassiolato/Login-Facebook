object FrmLoginFacebookView: TFrmLoginFacebookView
  Left = 0
  Top = 0
  Caption = 'Login com Facebook'
  ClientHeight = 418
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PnlCancelar: TPanel
    Left = 0
    Top = 0
    Width = 426
    Height = 41
    Align = alTop
    Caption = 'Cancelar'
    Color = clHotLight
    ParentBackground = False
    TabOrder = 0
    OnClick = PnlCancelarClick
  end
  object WebBrowser: TWebBrowser
    Left = 0
    Top = 41
    Width = 426
    Height = 377
    Align = alClient
    TabOrder = 1
    OnNavigateComplete2 = WebBrowserNavigateComplete2
    ExplicitWidth = 300
    ExplicitHeight = 150
    ControlData = {
      4C000000072C0000F72600000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
end
