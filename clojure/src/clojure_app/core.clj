;; clojure/sr
(ns clojure-app.core
  (:require [compojure.core :refer :all]
            [compojure.route :as route]
            [ring.adapter.jetty :refer [run-jetty]]
            [ring.util.response :refer [response resource-response]])
  (:gen-class))

(defn homepage []
  {:status 200
   :headers {"Content-Type" "text/html"}
   :body (slurp "resources/public/index.html")})

(defroutes app-routes
  (GET "/" []
    (homepage))
  (route/not-found "Not Found"))

(def app app-routes)

(defn -main [& args]
  (run-jetty app {:port 3000 :join? false}))
