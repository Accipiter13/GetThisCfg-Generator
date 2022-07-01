# GetThisCfg-Generator

[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-blue.svg)](./LICENSE)

A simple powershell DFIR-Orc's GetThis tool configuration file generator.

## Description

DFIR-Orc (see [official documentation](https://dfir-orc.github.io)) is an Open-Source digital forensics collection tool. 
The goal of **GetThisCfg-Generator** is to easily create configuration files required to collect artifacts.

## Usage

./GetThisCfg-Generator [-FileName] \<String\> \[\[-Lim\]\]

## Parameters

|   Parameters  |  Type  |                         Description                        | Optional |
|:-------------:|:------:|:----------------------------------------------------------:|:--------:|
| **-FileName** | String |              Name or path of the output file.              |    NO    |
|    **-Lim**   | Switch | Used to indicate if sample size limitations are to be set. |    YES   |

## Runtime interactions

The script will ask for informations to write to the configuration file at runtime. In order of occurence :

- If the file already exists, the generator will ask if it may override it.
- If **-Lim** is specified, limitations are prompted next :
  - MaxPerSampleBytes : The maximum size (in bytes) per sample e.g. 25438, 25MB, 1GB...
  - MaxTotalBytes     : The maximum size (in bytes) of the output archive, following the same logic as MaxPerSampleBytes.
  - MaxSampleCount    : The maximum number of samples to collect.
- Sample name : The name of the sample to collect (e.g. MFT, Prefetch, EventLogs...)
- Match type  : [See this page from DFIR-Orc documentation for details](https://dfir-orc.github.io/configuring_ntfs_opt.html#possible-attributes-of-a-ntfs-find-element)
- Sample path : The path to the targeted artifact (e.g. \\$MFT, \\Windows\\Prefetch\\\*.pf)

Multiple *Sample Name* can be set, but you need to configure the *Match Type* and *Sample Path* one at a time.

## License

The content of this repository is avaliable under the [Unlicense license](./LICENSE), and as such, is released as part of the public domain.
