## Trim, Assemble, Annotate pipeline

This is a messy repository to catalogue tools and write tests for a de-novo paired-end read assembly and annotation pipeline.

### Tools used and their closest container(s)
| tool used    | closest StaPH-B image(s) | own image                                                                                                                                         |
|--------------|--------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| bbtools/35.92 |[38.76, 38.86, 38.94](https://github.com/StaPH-B/docker-builds/tree/226c73210e9e711d4e6d6519fe799e5313a6d32d/bbtools)| [38.94](https://github.com/SarahNadeau/bioinf-containers/tree/master/trim_asm_annot/remove_phix) (toyed around with logging, use StaPH-B instead) |
| trimmomatic/0.35 |[0.38, 0.39](https://github.com/StaPH-B/docker-builds/tree/226c73210e9e711d4e6d6519fe799e5313a6d32d/trimmomatic) |                                                                                                                                                   |
| pear/0.9.10 |None| [0.9.11](https://github.com/SarahNadeau/bioinf-containers-secret) (can't be shared publicly)                                                      
| kraken/1.0.0 |[1.0.0 with MiniKraken database](https://github.com/StaPH-B/docker-builds/tree/master/kraken) |                                                                                                                                                   |
| kraken/2.0.8 |[2.0.8 with either MiniKraken2_v1_8GB or kraken2_h+v database](https://github.com/StaPH-B/docker-builds/tree/master/kraken2) |                                                                                                                                                   |
| SPAdes/3.13.0 |[3.8.0](https://github.com/StaPH-B/docker-builds/tree/master/spades) |                                                                                                                                                   |
| bwa/0.7.17 |[0.7.17](https://github.com/StaPH-B/docker-builds/tree/master/bwa/0.7.17) |                                                                                                                                                   |
| samtools/1.9 |[1.9](https://github.com/StaPH-B/docker-builds/tree/master/samtools) |                                                                                                                                                   |
| pilon/1.22 |[1.23.0](https://github.com/StaPH-B/docker-builds/tree/master/pilon/1.23.0) |                                                                                                                                                   |
| BEDTools/2.27.1 |[2.29.2](https://github.com/StaPH-B/docker-builds/tree/master/bedtools) |                                                                                                                                                   |
| mlst/2.16 |[2.16.2](https://github.com/StaPH-B/docker-builds/tree/master/mlst) |                                                                                                                                                   |
| barrnap/0.8 |None | [0.8](https://github.com/SarahNadeau/bioinf-containers/tree/master/barrnap/0.8)                                                                   |
| perl/5.16.1-MT |Just for running prokka, I think? |                                                                                                                                                   |
| prokka/1.14.3 |[1.14.0, 1.14.5](https://github.com/StaPH-B/docker-builds/tree/master/prokka) |                                                                                                                                                   |
| rnammer/1.2 |None | For academic use only, replace with barrnap                                                                                                       |
| ncbi-blast+/2.9.0 |None | [2.9.0](https://github.com/SarahNadeau/bioinf-containers/tree/master/ncbi_blast%2B/2.9.0)                                                         |

### Testing notes
* Using phix174_ill.ref.fa.gz PhiX genome from bbtools
* Using TruSeq3-PE.fa adaptors from trimmomatic
* FLASH assumes PHRED 33 quality scores, doesn't have 'auto' option like PEAR
* FLASH has an ad-hoc way to correct for 3' end of reads being more error prone -- I disabled this check because the default value was inappropriate, should be okay given that input is already quality-trimmed?
* Using minikraken_20171013_4GB database for kraken
* Only a subset of reads run through kraken 1.0