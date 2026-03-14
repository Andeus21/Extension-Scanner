# ====================================================================
# ESCÁNER  - Analizer ( MEMORIA RAM )
# ====================================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host

$Banner = @"
 █████╗ ███╗  ██╗██████╗ ███████╗██╗   ██╗███████╗
██╔══██╗████╗  ██║██╔══██╗██╔════╝██║   ██║██╔════╝
███████║██╔██╗ ██║██║  ██║█████╗  ██║   ██║███████╗
██╔══██║██║╚██╗██║██║  ██║██╔══╝  ██║   ██║╚════██║
██║  ██║██║ ╚████║██████╔╝███████╗╚██████╔╝███████║
╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝ ╚═════╝ ╚══════╝                                 
                      
  ▀▄▀▄▀▄▀▄▀▄▀▄  ☣︎ INFECTION  ☣︎  ▀▄▀▄▀▄▀▄▀▄▀▄▀                   
"@

Write-Host $Banner -ForegroundColor Magenta
Write-Host "_____________________________________________________" -ForegroundColor DarkMagenta
Write-Host "Realizando radiografía a la Memoria RAM de Minecraft (javaw.exe)...`n" -ForegroundColor DarkGray

# Base de datos de DLLs de inyectores conocidos
$DllsIlegales = @("slinky", "doomsday", "vape", "koid", "manthe", "b7", "kurumi", "injector", "cheat")

try {
    # 1. Buscar el juego vivo en la Memoria RAM
    $ProcesoJava = Get-Process -Name "javaw" -ErrorAction Stop
    $Detecciones = 0

    Write-Host "[i] Minecraft detectado (PID: $($ProcesoJava.Id)). Extrayendo módulos inyectados...`n" -ForegroundColor Cyan

    # 2. Extraer todas las librerías (.dll) inyectadas en el juego
    $Modulos = $ProcesoJava.Modules

    foreach ($Modulo in $Modulos) {
        $NombreDll = $Modulo.ModuleName.ToLower()
        $RutaDll = $Modulo.FileName

        # Ignorar librerías nativas de Windows y Java para no hacer ruido
        if ($RutaDll -match "C:\\Windows\\" -or $RutaDll -match "jre" -or $RutaDll -match "jdk") { continue }

        # 3. Comparar contra nuestra base de datos de Hacks
        foreach ($Trampa in $DllsIlegales) {
            if ($NombreDll -match $Trampa) {
                $Detecciones++
                Write-Host "   [!] INYECCIÓN EN MEMORIA DETECTADA (GHOST CLIENT):" -ForegroundColor Red
                Write-Host "       => Archivo Inyectado: $NombreDll" -ForegroundColor Yellow
                Write-Host "       => Ruta de Origen: $RutaDll" -ForegroundColor DarkGray
                Write-Host "       => Veredicto: El usuario inyectó un hack externo en la RAM del juego.`n" -ForegroundColor Red
                break
            }
        }
    }

    if ($Detecciones -eq 0) {
        Write-Host "[i] Memoria limpia. No se detectaron DLLs ilegales inyectadas en Minecraft." -ForegroundColor Green
    } else {
        Write-Host "======================================================" -ForegroundColor DarkMagenta
        Write-Host "Resumen: Se detectaron $Detecciones inyecciones maliciosas en la RAM." -ForegroundColor Yellow
    }

} catch {
    Write-Host "[x] No se encontró Minecraft abierto (javaw.exe) o necesitas ejecutar PowerShell como Administrador." -ForegroundColor Red
}
