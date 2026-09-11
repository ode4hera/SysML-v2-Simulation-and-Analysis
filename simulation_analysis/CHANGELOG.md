# Simulation and Analysis Changelog

## Unreleased: FMI package in its own file

- The `'FMIv2.0.5'` package moved out of `ModelBasedDesign.sysml` into its own file `FMI.sysml` as a library package; `ModelBasedDesign` still re-exports it, so existing imports keep working

## 2026-07-14: v2.0.2

- Support changes in requirements management library (changed SYSMOD dependency)

## 2026-05-29: v2.0.1

- Reworked the MDAO problem definition structure to be more SysML v2-native
- Reused design variable and metric attribute definitions from the Architecture Design library
- Added support for vector and tensor variables in MDAO
- Added uncertainty quantification and UMDAO (Uncertain MDAO) problem definition
- Added time-domain metric extraction logic to the MBD model definition
- Added example for an MDAO problem using an MBD model as a tool
