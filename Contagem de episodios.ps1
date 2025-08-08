# === CONFIGURAÇÕES ===
$extensoes = @(".mp4", ".mkv", ".avi", ".srt")

# === COLETA DE EPISÓDIOS ===
$episodios = Get-ChildItem | Where-Object {
    -not $_.PSIsContainer -and $extensoes -contains $_.Extension.ToLower()
} | ForEach-Object {
    # Captura qualquer formato que tenha E + número (E01, E1, etc.)
    if ($_.Name -match "E(\d{1,2})") {
        [int]$matches[1]
    }
} | Sort-Object -Unique

if (-not $episodios) {
    Write-Host "Nenhum episódio encontrado no padrão E1, E01, etc."
    return
}

# === DETECTA FALTANDO ===
$min = $episodios | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
$max = $episodios | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum

$faltando = @()
for ($i = $min; $i -le $max; $i++) {
    if ($episodios -notcontains $i) {
        $faltando += $i
    }
}

Write-Host "📂 Total encontrado: $($episodios.Count) episódios"
Write-Host "📃 Lista: $($episodios -join ', ')"
if ($faltando.Count -gt 0) {
    Write-Host "❌ Episódios faltando: $($faltando -join ', ')"
} else {
    Write-Host "✅ Nenhum episódio faltando na sequência"
}
