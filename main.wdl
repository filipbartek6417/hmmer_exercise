version 1.0

task run_nhmmer {
  input {
    File hmm
    File reference
    File environment_yml
  }

  command {
    set -e

    conda env create -f ~{environment_yml} -p ./env || conda env update -f ~{environment_yml} -p ./env
    source activate ./env
    conda -V
    conda install bioconda::hmmer
    nhmmer --cpu 32 --notextw --noali --tblout TR.model.out ~{hmm} ~{reference}
  }

  output {
    File model = "TR.model.out"
  }

  runtime {
    docker: "continuumio/miniconda3"
    memory: "64G"
    disks: "local-disk 300 SSD"
    cpu: 32
  }
}

workflow hmmer_wf {
  input {
    File hmm
    File reference
    File environment_yml
  }

  call run_nhmmer {
    input:
      hmm = hmm,
      reference = reference,
      environment_yml = environment_yml
  }

  output {
    File model = run_nhmmer.model
  }
}
