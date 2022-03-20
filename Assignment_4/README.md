# Assignment_4 #
This is the 4th assignment in the dataprocessing course

## Files
|File/Directory                 |Contains                               |  
|---                            |---                                    |
|config                         |the config file                        |
|workflow                       |all snakemake modules and scripts      |

## Running the script
To run everything you will need to run the following command from the ``Assignment_4`` directory:
``` 
snakemake --snakefile workflow/main.smk --cores {cores}
```

## Config
In the config file you will need to give the absolute path to your data and to where you would
like to store the results. You will also have to specify the location of the picard
tool and the samples you wish to use.

## Contact

* K. Notebomer
  * k.a.notebomer@st.hanze.nl