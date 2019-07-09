unit uLoginFacebookController;

interface

uses
  StdCtrls, REST.Client, REST.Authenticator.OAuth, JSON, Vcl.ExtCtrls,
  System.Net.HttpClient, Classes, IPPeerClient;

type
  TLoginFacebook = class
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    RESTClient: TRESTClient;
    OAuth2_Facebook: TOAuth2Authenticator;
    procedure RESTRequestAfterExecute(Sender: TCustomRESTRequest);
  private
    FCampoNome: TEdit;
    FCampoEmail: TEdit;
    FImagem: TImage;
    FAccessToken: string;
    function LoadStreamFromURL(url: string): TMemoryStream;
    procedure ConfigurarComponentesREST;
    procedure CriarComponentesREST;
    procedure DestruirComponentesREST;
    procedure PegarTokenNavegador;
    function TiraAspas(psValor: string): string;
    procedure CarregarFoto(psURLFoto: string);
  published
    property CampoNome: TEdit read FCampoNome write FCampoNome;
    property CampoEmail: TEdit read FCampoEmail write FCampoEmail;
    property Imagem: TImage read FImagem write FImagem;
  public
    constructor Create;
    destructor Destroy; override;
    procedure FazerRequisicaoFacebook;
  end;

implementation

uses
  uLoginFacebookView, SysUtils, Web.HTTPApp, REST.Utils, Dialogs,
  System.NetEncoding;

function TLoginFacebook.LoadStreamFromURL(url: string): TMemoryStream;
var
  MS: TMemoryStream;
  http: THTTPClient;
begin
  MS := TMemoryStream.Create;
  http := THTTPClient.Create;

  try
    http.Get(url, MS);

    MS.Position := 0;
    Result := MS;
  finally
  end;
  result := TMemoryStream.Create
end;

function TLoginFacebook.TiraAspas(psValor: string): string;
begin
  Result := StringReplace(psValor, '"', '', [rfReplaceAll]);
end;

procedure TLoginFacebook.CarregarFoto(psURLFoto: string);
var
  MS: TMemoryStream;
begin
  try
    try
      MS := TMemoryStream.Create;
      MS := LoadStreamFromURL(psURLFoto);

      FImagem.Picture.Graphic.LoadFromStream(MS);
    finally
      FreeAndNil(MS);
    end;
  except
    ShowMessage('Erro a criar a foto');
  end;
end;

procedure TLoginFacebook.RESTRequestAfterExecute(Sender: TCustomRESTRequest);
var
  LJsonObj: TJSONObject;
  LElements: TJSONValue;
  msg,
  url_foto,
  nome,
  email,
  user_id: string;
begin
  msg := '';
  FAccessToken := '';

  if Assigned(RESTResponse.JSONValue) then
    msg := RESTResponse.JSONValue.ToString;

  LJsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(msg), 0) as TJSONObject;

  user_id := HTMLDecode(TiraAspas(LJsonObj.Get('id').JsonValue.ToString));
  email := TiraAspas(LJsonObj.Get('email').JsonValue.ToString);
  nome := TiraAspas(LJsonObj.Get('first_name').JsonValue.ToString);
  nome := nome + ' ' + TiraAspas(LJsonObj.Get('last_name').JsonValue.ToString);
  LElements := TJSONObject(LJsonObj.Get('picture').JsonValue).Get('data').JsonValue;
  url_foto := TiraAspas(TJSONObject(LElements).Get('url').JsonValue.ToString);

  CarregarFoto(url_foto);

  FCampoNome.Text := nome;
  FCampoEmail.Text := email;
end;

procedure TLoginFacebook.CriarComponentesREST;
begin
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  RESTClient := TRESTClient.Create(nil);
  OAuth2_Facebook:= TOAuth2Authenticator.Create(nil);
end;

procedure TLoginFacebook.DestruirComponentesREST;
begin
  FreeAndNil(RESTRequest);
  FreeAndNil(RESTResponse);
  FreeAndNil(RESTClient);
  FreeAndNil(OAuth2_Facebook);
end;

procedure TLoginFacebook.ConfigurarComponentesREST;
begin
  RESTRequest.Client := RESTClient;
  RESTRequest.Response := RESTResponse;
  RESTClient.Authenticator := OAuth2_Facebook;
  RESTRequest.OnAfterExecute := RESTRequestAfterExecute;
  ConfigurarComponentesREST;
end;

constructor TLoginFacebook.Create;
begin
  inherited;
  CriarComponentesREST;
end;

destructor TLoginFacebook.Destroy;
begin
  DestruirComponentesREST;
  inherited;
end;

procedure TLoginFacebook.PegarTokenNavegador;
var
  LURL: string;
begin
  LURL := 'https://www.facebook.com/dialog/oauth'
    + '?client_id=' + URIEncode('446206296204949')//ID do seu app criado no Facebook
    + '&response_type=token'
    + '&scope=' + URIEncode('public_profile,email')
    + '&redirect_uri=' + URIEncode('https://www.facebook.com/connect/login_success.html');

  FrmLoginFacebookView := TFrmLoginFacebookView.Create(nil);
  FrmLoginFacebookView.WebBrowser.Navigate(LURL);
  FrmLoginFacebookView.ShowModal;
  FAccessToken := FrmLoginFacebookView.AccessToken;
end;

procedure TLoginFacebook.FazerRequisicaoFacebook;
begin
  try
    PegarTokenNavegador;

    if FAccessToken <> '' then
    begin
      RESTRequest.ResetToDefaults;
      RESTClient.ResetToDefaults;
      RESTResponse.ResetToDefaults;

      RESTClient.BaseURL := 'https://graph.facebook.com';
      RESTClient.Authenticator := OAuth2_Facebook;
      RESTRequest.Resource := 'me?fields=first_name,last_name,email,picture.height(150)';
      OAuth2_Facebook.AccessToken := FAccessToken;

      RESTRequest.Execute;
    end;
  except on e:exception do
    ShowMessage(e.Message);
  end;
end;

end.
