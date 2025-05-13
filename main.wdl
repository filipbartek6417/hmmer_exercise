version 1.0

task run_nhmmer {
  input {
    File hmm
    File reference
  }

  command {
    set -e

    apt-get update && apt-get install -y apt-utils conda python3 pip
    conda install bioconda::hmmer
    nhmmer --cpu 32 --notextw --noali --tblout TR.model.out ~{hmm} ~{reference}
  }

  output {
    File model = "TR.model.out"
  }

  runtime {
    docker: "ubuntu:20.04"
    memory: "64G"
    disks: "local-disk 300 SSD"
    cpu: 32
  }
}

workflow hmmer_wf {
  input {
    File hmm
    File reference
  }

  call run_hmmer {
    input:
      hmm = hmm,
      reference = reference
  }

  output {
    File model = run_hmmer.stats
  }
}
