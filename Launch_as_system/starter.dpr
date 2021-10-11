program starter;

{$R starter.res}

uses
  SysUtils, Windows, ShellAPI, WinSvc;
  
var
    HResInfo, hf, HGlobal: THandle;
    Buffer : pchar;
    I: Cardinal;
    isOk: boolean;
    scm: SC_Handle;
    service: SC_Handle;

begin
  HResInfo:=FindResource(HInstance, 'LAUNCHER', RT_RCDATA);
  HGlobal:=LoadResource(HInstance, HResInfo);
  if HGlobal = 0 then
     MessageBox(0, 'error', 'error', 0);
  
  Buffer:=LockResource(HGlobal);
  hf:=CreateFile('tslauncher.exe', GENERIC_ALL, 0, nil, CREATE_ALWAYS,
    FILE_ATTRIBUTE_NORMAL, 0) ;
  WriteFile(hf, Buffer^, SizeOfResource(HInstance, HResInfo), i, nil);
  CloseHandle(hf);
  UnlockResource(HGlobal);
  FreeResource(HGlobal);

  ShellExecute(0, 'open', 'tslauncher.exe', '/install /silent', '', 0);
  Sleep(500);
  scm:=OpenSCManager('.', nil, SC_MANAGER_ALL_ACCESS);
  service:=OpenService(scm, 'tslaunch', SERVICE_ALL_ACCESS);
  isOk:=StartService(service, 0, Buffer);
  Sleep(500);
  ShellExecute(0, 'open', 'tslauncher.exe', '/uninstall /silent', '', 0);
  Sleep(100);
  DeleteFile('tslauncher.exe');
  if isOk then
    MessageBox(0, 'Service launched, now wait for message from SC', 'Launcher', 0)
  else
    MessageBox(0, 'Error launching service', 'Launcher', 0);
  while FileExists('tslauncher.exe') do begin
    DeleteFile('tslauncher.exe');
    Sleep(500);
  end;
end.
