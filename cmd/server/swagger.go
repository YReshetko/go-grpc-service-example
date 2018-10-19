package main

import (
	"fmt"
	"net/http"
	"strings"
)

func NewSwaggerHandler(swaggerDir string) http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("/swagger/", func(writer http.ResponseWriter, request *http.Request) {
		writer.Header().Set("Access-Control-Allow-Origin", "*")
		http.ServeFile(writer, request, fmt.Sprintf("%s/%s", swaggerDir, strings.TrimPrefix(request.URL.Path, "/swagger/")))
	})

	return mux
}
