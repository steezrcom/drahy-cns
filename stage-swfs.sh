#!/usr/bin/env bash
# Re-stages SWFs into public/swf/ from the upstream archive at anat.lf1.cuni.cz.
# Run this only if you need to refresh from upstream — the staged copies under
# public/swf/ are the source of truth for the deployed site and are checked in.
set -euo pipefail

cd "$(dirname "$0")"

URL="https://anat.lf1.cuni.cz/materialy/drahyCNS.zip"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Downloading $URL"
curl -fsSL -o "$TMP/source.zip" "$URL"
unzip -q "$TMP/source.zip" -d "$TMP/extracted"

DRAHY="$TMP/extracted/Interaktivni drahy-hlavn” sensitivn” a motoricke"
PROP="$TMP/extracted/Propriocepce a crbl okruhy"
OUT="public/swf"

declare -a MAP=(
  "drahy/lemniscal-pathway.swf|${DRAHY}/lemniscal pathway/tr_sp_bulb_th_co_CZ EN.swf"
  "drahy/tr-corticospinalis.swf|${DRAHY}/TR cortico_spinalis/tr_corticospinalis EN CZ.swf"
  "drahy/tr-corticospinalis-mri.swf|${DRAHY}/MRI_corticospinal_final/CORTICOSPINAL_mri_CZ_EN.swf"
  "drahy/tr-spinothalamicus.swf|${DRAHY}/tr spino_thalamicus/tr_spinothalamicus_EN_CZ.swf"
  "drahy/tr-rubrospinalis.swf|${DRAHY}/tr Rubro_spinalis/Tr_rubro_Spinalis CZ EN.swf"
  "drahy/tr-tectospinalis.swf|${DRAHY}/tr_Tecto_spinalis/Tr_Tecto_Spinalis CZ EN.swf"
  "drahy/tr-vestibulospinalis.swf|${DRAHY}/tr_vestibulo_spinalis/Tr_Vestibulo_Spinalis CZ_EN.swf"
  "drahy/tr-reticulospinalis.swf|${DRAHY}/tr_reticulo_spinalis/Tr_Reticulo_spinalis CZ EN.swf"
  "drahy/tr-spinoreticularis.swf|${DRAHY}/tr_spino_reticularis/Tr_Spino_reticularis CZ EN.swf"
  "drahy/kviz-lemniscalni.swf|${DRAHY}/KVIZ_LEMNISC/KVIZ_LEMNISC.swf"
  "drahy/kviz-corticospinalis.swf|${DRAHY}/C_Sp_KVIZ/KVIZ_C_Sp.swf"
  "drahy/kviz-spinothalamicus.swf|${DRAHY}/Sp_Th_Kviz/KVIZ_Sp_Th.swf"
  "propriocepce/zadni-provazce.swf|${PROP}/draha zadnich provazcu/tr_sp_bulb_th_co_CZ EN nase.swf"
  "propriocepce/staticka-propriocepce.swf|${PROP}/staticka propriocepce/tr_sp_bulb_th_co_CZ EN staticka.swf"
  "propriocepce/tr-spinocerebellaris-dorsalis.swf|${PROP}/tr_sp_crbl_dors/tr_sp_crbl_dors_CZ EN.swf"
  "propriocepce/tr-spinocerebellaris-ventralis.swf|${PROP}/tr_sp_crbl_ventr/tr_sp_crbl_ventr_CZ EN.swf"
  "propriocepce/tr-spinoolivaris.swf|${PROP}/tr_sp_oliv/tr_sp_olivaris_CZ EN.swf"
  "propriocepce/tr-vestibulocerebellaris-direct.swf|${PROP}/tr_ve_crbl_dir/Tr_Vestibulo_crbl dir CZ_EN.swf"
  "propriocepce/tr-vestibulocerebellaris-indirect.swf|${PROP}/tr_ve_crbl_indir/Tr_Vestibulo_crbl indir CZ_EN.swf"
  "propriocepce/eferenty-cerebella.swf|${PROP}/efer_crbl/eferenty crbl.swf"
  "propriocepce/neocerebellarni-okruh.swf|${PROP}/neocrbl okruh/mozeckovy_okruh_cz.swf"
  "propriocepce/papezuv-okruh.swf|${PROP}/kontroln¡ crbl okruh/papez okruh.swf"
  "propriocepce/mapy-drah.swf|${PROP}/poloha hlavn¡ch drah v prurezech/mapy drah.swf"
  "propriocepce/kviz-recepce.swf|${PROP}/kviz_rcp/kviz_rcp.swf"
  "propriocepce/kviz-staticka.swf|${PROP}/kviz_staticka/kviz_staticka.swf"
  "propriocepce/kviz-spinocerebellaris-dorsalis.swf|${PROP}/kviz_spi_crbl_dors/kviz_spi_crbl_dors.swf"
  "propriocepce/kviz-spinocerebellaris-ventralis.swf|${PROP}/kviz_spi_crbl_ven/kviz_spi_crbl_ven.swf"
  "propriocepce/kviz-spinoolivaris.swf|${PROP}/kviz_spi_oliv/kviz_spi_oliv.swf"
  "propriocepce/kviz-vestibulocerebellaris.swf|${PROP}/kviz_ve_crbl/kviz_ve_crbl.swf"
  "propriocepce/kviz-neocerebellarni.swf|${PROP}/kviz_neocrbl/kviz_neocrbl.swf"
)

mkdir -p "$OUT/drahy" "$OUT/propriocepce"

missing=0
for entry in "${MAP[@]}"; do
  dst="${entry%%|*}"
  src="${entry#*|}"
  if [ ! -f "$src" ]; then
    echo "MISSING: $src" >&2
    missing=$((missing + 1))
    continue
  fi
  cp -f "$src" "$OUT/$dst"
done

echo "Staged $((${#MAP[@]} - missing))/${#MAP[@]} SWFs into $OUT"
[ "$missing" -eq 0 ]
