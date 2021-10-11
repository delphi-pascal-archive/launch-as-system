unit Unit1;

interface

uses
  Windows, Messages, SvcMgr;

type
  Ttslaunch = class(TService)
    procedure ServiceExecute(Sender: TService);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  tslaunch: Ttslaunch;

implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  tslaunch.Controller(CtrlCode);
end;

function Ttslaunch.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure Exec32(const Param: PChar);
var
  Si : TStartupInfo;
  PrI : TProcessInformation;
begin
FillChar(Si, SizeOf(Si), 0);
Si.cb:=SizeOf(Si);
CreateProcess(nil, Param, nil, nil, false,
  CREATE_DEFAULT_ERROR_MODE, nil, nil ,Si , PrI);
end;

procedure Ttslaunch.ServiceExecute(Sender: TService);
begin
  Exec32('cmd.exe');
end;

end.
