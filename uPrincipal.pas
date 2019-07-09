unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, uLoginFacebookController;

type
  TFrmPrincipal = class(TForm)
    EdtNome: TEdit;
    ImgFoto: TImage;
    EdtEmail: TEdit;
    BtnRequisicao: TButton;
    LblNome: TLabel;
    LblEmail: TLabel;
    procedure BtnRequisicaoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

procedure TFrmPrincipal.BtnRequisicaoClick(Sender: TObject);
var
  FLoginFacebook: TLoginFacebook;
begin
  FLoginFacebook := TLoginFacebook.Create;
  try
    FLoginFacebook.CampoNome := EdtNome;
    FLoginFacebook.CampoEmail := EdtEmail;
    FLoginFacebook.Imagem := ImgFoto;
    FLoginFacebook.FazerRequisicaoFacebook;
  finally
    FreeAndNil(FLoginFacebook);
  end;
end;

end.
