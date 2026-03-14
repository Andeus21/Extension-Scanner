Clear-Host
Write-Host "=========================================================" -ForegroundColor DarkGray
Write-Host "🕵️‍♂️ ESCÁNER MAGIC BYTES INICIADO..." -ForegroundColor Cyan
Write-Host "Analizando Zonas Calientes: Descargas, Escritorio..." -ForegroundColor DarkGray
Write-Host "=========================================================`n" -ForegroundColor DarkGray

# Definir carpetas a escanear (puedes agregar más)
$Carpetas = @(
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Desktop"
)

# Extensiones "Inocentes" que los tramposos usan para esconder hacks
$ExtensionesFalsas = @(".mp4", ".mp3", ".txt", ".png", ".jpg", ".docx", ".pdf")
$CamuflajesEncontrados = 0

foreach ($Carpeta in $Carpetas) {
    # Buscar archivos con las extensiones de la lista
    $Archivos = Get-ChildItem -Path $Carpeta -File -Recurse -ErrorAction SilentlyContinue | Where-Object { $ExtensionesFalsas -contains $_.Extension }

    foreach ($Archivo in $Archivos) {
        try {
            # LEER EL ADN (Los primeros 2 bytes)
            $Bytes = Get-Content -Path $Archivo.FullName -Encoding Byte -TotalCount 2 -ErrorAction Stop
            $Hex = [System.BitConverter]::ToString($Bytes)
            
            # MZ (4D-5A) = Archivo Ejecutable (.exe, .dll)
            if ($Hex -eq "4D-5A") {
                $CamuflajesEncontrados++
                Write-Host "[!] ALERTA DE CAMUFLAJE (SPOOFING) DETECTADA:" -ForegroundColor Red
                Write-Host "   => Ruta del Archivo: $($Archivo.FullName)" -ForegroundColor Yellow
                Write-Host "   => Falsa Extensión: $($Archivo.Extension)" -ForegroundColor White
                Write-Host "   => Verdadero: Programa Ejecutable (.EXE / DLL)" -ForegroundColor Red
                Write-Host "   => Veredicto: El usuario ocultó un inyector cambiándole el nombre.`n" -ForegroundColor DarkGray
            }
            # PK (50-4B) = Archivo Comprimido / Java (.jar, .zip)
            elseif ($Hex -eq "50-4B") {
                $CamuflajesEncontrados++
                Write-Host "[!] ALERTA DE CAMUFLAJE (SPOOFING) DETECTADA:" -ForegroundColor Red
                Write-Host "   => Ruta del Archivo: $($Archivo.FullName)" -ForegroundColor Yellow
                Write-Host "   => Falsa Extensión: $($Archivo.Extension)" -ForegroundColor White
                Write-Host "   => Verdadero: Archivo Comprimido Java (.JAR / ZIP)" -ForegroundColor Red
                Write-Host "   => Veredicto: El usuario ocultó un mod ilegal cambiándole el nombre.`n" -ForegroundColor DarkGray
            }
        } catch {
            # Ignorar archivos bloqueados
        }
    }
}

Write-Host "=========================================================" -ForegroundColor DarkGray
Write-Host "[i] Escaneo finalizado. $CamuflajesEncontrados archivos camuflados encontrados." -ForegroundColor Green
