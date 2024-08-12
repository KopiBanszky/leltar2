[Setup]
AppName=leltar_2
AppVersion=2.0.51
DefaultDirName={pf}\leltar_2
DefaultGroupName=leltar_2
OutputBaseFilename=leltar_installer
Compression=lzma
SolidCompression=yes

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\leltar_2"; Filename: "{app}\leltar_2.exe"
Name: "{group}\Uninstall leltar_2"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\leltar_2.exe"; Description: "Launch leltar"; Flags: nowait postinstall skipifsilent
