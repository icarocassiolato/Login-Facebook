unit uLoginFacebookView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw, Vcl.ExtCtrls;

type
  TWebFormRedirectEvent = procedure(const AURL : string; var DoCloseWebView: boolean) of object;

type
  TFrmLoginFacebookView = class(TForm)
    PnlCancelar: TPanel;
    WebBrowser: TWebBrowser;
    procedure PnlCancelarClick(Sender: TObject);
    procedure WebBrowserNavigateComplete2(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
  private
    { Private declarations }
    FOnBeforeRedirect : TWebFormRedirectEvent;
    FAccessToken: string;
    procedure Facebook_AccessTokenRedirect(const AURL: string;
      var DoCloseWebView: boolean);
  public
    { Public declarations }
    property OnBeforeRedirect: TWebFormRedirectEvent read FOnBeforeRedirect write FOnBeforeRedirect;
    property AccessToken: string read FAccessToken write FAccessToken;
  end;

var
  FrmLoginFacebookView: TFrmLoginFacebookView;

implementation

{$R *.dfm}

procedure TFrmLoginFacebookView.Facebook_AccessTokenRedirect(const AURL: string; var DoCloseWebView: boolean);
var
  LATPos: integer;
  LToken: string;
begin
  try
    DoCloseWebView := False;
    LATPos := Pos('access_token=', AURL);

    if (LATPos > 0) then
    begin
      LToken := Copy(AURL, LATPos + 13, Length(AURL));

      if (Pos('&', LToken) > 0) then
        LToken := Copy(LToken, 1, Pos('&', LToken) - 1);

      FAccessToken := LToken;

      if (LToken <> '') then
        DoCloseWebView := True;
    end
    else
    begin
      if Pos('api_key=', AURL) > 0 then
        Exit;

      if (Pos('access_denied', AURL) > 0) then
      begin
        FAccessToken := '';
        DoCloseWebView := True;
      end;
    end;
  except on E: Exception do
    ShowMessage(E.Message);
  end;
end;

procedure TFrmLoginFacebookView.PnlCancelarClick(Sender: TObject);
begin
  FAccessToken := '';
  ModalResult := mrOk;
end;

procedure TFrmLoginFacebookView.WebBrowserNavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
var
  CloseWebView: boolean;
begin
  if URL <> '' then
    Facebook_AccessTokenRedirect(URL, CloseWebView);

  if CloseWebView then
    Close;
end;

end.
