object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Login com Facebook'
  ClientHeight = 212
  ClientWidth = 212
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ImgFoto: TImage
    Left = 56
    Top = 93
    Width = 105
    Height = 105
  end
  object LblNome: TLabel
    Left = 22
    Top = 11
    Width = 27
    Height = 13
    Caption = 'Nome'
  end
  object LblEmail: TLabel
    Left = 22
    Top = 38
    Width = 28
    Height = 13
    Caption = 'E-Mail'
  end
  object EdtNome: TEdit
    Left = 56
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object EdtEmail: TEdit
    Left = 56
    Top = 35
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object BtnRequisicao: TButton
    Left = 56
    Top = 62
    Width = 121
    Height = 25
    Caption = 'Fazer Requisi'#231#227'o'
    TabOrder = 2
    OnClick = BtnRequisicaoClick
  end
end
