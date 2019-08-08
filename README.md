# nghttpx_polipo
to convert sock5 to https proxy

`docker build -t nghttpx_polipo https://github.com/yangwe1/nghttpx_polipo.git`

`docker run -v /path/to/directory/of/certs:/certs -p 9699:9699 --env CERT=cert_file_name --env KEY=key_file_name -d nghttpx_polipo`
