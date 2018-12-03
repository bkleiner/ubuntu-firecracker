package main

import (
	"archive/tar"
	"compress/gzip"
	"flag"
	"io"
	"log"
	"os"
	"strconv"
)

func main() {
	flag.Parse()

	name := flag.Arg(0)
	size, err := strconv.Atoi(flag.Arg(1))
	if err != nil {
		log.Fatal(err)
	}

	if err := os.Mkdir(name, 0755); err != nil {
		log.Fatal(err)
	}

	f, err := os.Open("output/ubuntu-bionic.tar.gz")
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	gzf, err := gzip.NewReader(f)
	if err != nil {
		log.Fatal(err)
	}

	archive := tar.NewReader(gzf)
	for {
		header, err := archive.Next()
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatal(err)
		}

		switch header.Typeflag {
		case tar.TypeDir:
			continue
		case tar.TypeReg:
			f, err := os.Create(name + "/" + header.Name)
			if err != nil {
				log.Fatal(err)
			}

			if _, err := io.Copy(f, archive); err != nil {
				log.Fatal(err)
			}

			if header.Name == "image.ext4" {
				size := int64(size * 1024 * 1024 * 1024)
				if err := f.Truncate(size); err != nil {
					log.Fatal(err)
				}
			}
		default:
			log.Fatal("unknown header entry")
		}
	}
}
