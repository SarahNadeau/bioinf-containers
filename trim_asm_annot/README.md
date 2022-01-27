## Trim, Assemble, Annotate pipeline

This is a messy repository to catalogue tools and write tests for a de-novo paired-end read assembly and annotation pipeline.

### Tools used and their closest container(s)
| tool used         | closest StaPH-B image(s) | own image (tested)                                                                                             |
|-------------------|--------------------------|----------------------------------------------------------------------------------------------------------------|
| bbtools/35.92     |[38.76, 38.86, 38.94](https://github.com/StaPH-B/docker-builds/tree/226c73210e9e711d4e6d6519fe799e5313a6d32d/bbtools)| [38.94](https://hub.docker.com/r/snads/bbtools/tags) | 
| trimmomatic/0.35  |[0.38, 0.39](https://github.com/StaPH-B/docker-builds/tree/226c73210e9e711d4e6d6519fe799e5313a6d32d/trimmomatic) | [0.39](https://hub.docker.com/r/snads/trimmomatic/tags)                                                        |
| pear/0.9.10       |None| [0.9.11](https://github.com/SarahNadeau/bioinf-containers-secret) Can't be shared publicly, replace with flash 
| flash      |None| [1.2.11](https://hub.docker.com/r/snads/flash/tags)                                                            |
| kraken/1.0.0      |[1.0.0 with MiniKraken database](https://github.com/StaPH-B/docker-builds/tree/master/kraken) | [1.0](https://hub.docker.com/r/snads/kraken/tags)                                                              |
| kraken/2.0.8      |[2.0.8 with either MiniKraken2_v1_8GB or kraken2_h+v database](https://github.com/StaPH-B/docker-builds/tree/master/kraken2) | [2.0.8-beta](https://hub.docker.com/r/snads/kraken2/tags)                                                                                                 |
| SPAdes/3.13.0     |[3.8.0](https://github.com/StaPH-B/docker-builds/tree/master/spades) | [3.15.3](https://hub.docker.com/r/snads/spades/tags)                                                           |
| bwa/0.7.17        |[0.7.17](https://github.com/StaPH-B/docker-builds/tree/master/bwa/0.7.17) | [0.7.17](https://hub.docker.com/r/snads/bwa/tags)                                                              |
| samtools/1.9      |[1.9](https://github.com/StaPH-B/docker-builds/tree/master/samtools) | [1.9](https://hub.docker.com/r/snads/samtools/tags)                                                            |
| pilon/1.22        |[1.23.0](https://github.com/StaPH-B/docker-builds/tree/master/pilon/1.23.0) | [1.23.0](https://hub.docker.com/r/snads/pilon/tags)                                                            |
| BEDTools/2.27.1   |[2.29.2](https://github.com/StaPH-B/docker-builds/tree/master/bedtools) | [2.29.2](https://hub.docker.com/r/snads/bedtools/tags)                                                         |
| mlst/2.16         |[2.16.2](https://github.com/StaPH-B/docker-builds/tree/master/mlst) | [2.17.6](https://hub.docker.com/r/snads/mlst/tags)                                                             |
| barrnap/0.8       |None | [0.8](https://hub.docker.com/r/snads/barrnap/tags)                                                             | 
| perl/5.16.1-MT    |Just for running prokka, I think? |                                                                                                                |
| prokka/1.14.3     |[1.14.0, 1.14.5](https://github.com/StaPH-B/docker-builds/tree/master/prokka) | [1.14.5](https://hub.docker.com/r/snads/prokka/tags)                                                           |
| rnammer/1.2       |None | For academic use only, replace with barrnap                                                                    |
| ncbi-blast+/2.9.0 |None | [2.9.0](https://hub.docker.com/r/snads/ncbi-blast-plus/tags)                                                   |

### Testing notes
* Tested version and checksum of software output when run on test Moraxella catarrhalis data, unless noted otherwise below
* Used phix174_ill.ref.fa.gz PhiX genome from bbtools
* Used TruSeq3-PE.fa adaptors from trimmomatic
* FLASH assumes PHRED 33 quality scores, doesn't have 'auto' option like PEAR
* FLASH has an ad-hoc way to correct for 3' end of reads being more error prone -- I disabled this check because the default value was inappropriate, should be okay given that input is already quality-trimmed?
* Used minikraken_20171013_4GB database for kraken, k2_standard_8gb_20210517 for kraken2
* Only ran a random sample of 1000 reads through kraken softwares
* Checked MLST matches known sequence type in addition to checksum
* Barrnap says it's less accurate than RNAmmer but "In practice, Barrnap will find all the typical rRNA genes... [it] may get the end points out by a few bases and will probably miss wierd rRNAs"
* Pilon didn't make any corrections on the test data - is this normal? Coverage was fairly good (~53x after trimming, filtering)
* Didn't interpret prokka results, just verified checksums are consistent
* Checked only that top BLAST result for extracted 16S is correct species, no checksum since 16S database is updated daily