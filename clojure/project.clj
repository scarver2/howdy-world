;; clojure/project.clj
(defproject clojure-app "0.1.0"
  :description "Howdy World Clojure endpoint"
  :dependencies [[org.clojure/clojure "1.11.1"]
                 [ring/ring-core "1.12.1"]
                 [ring/ring-jetty-adapter "1.12.1"]
                 [ring/ring-mock "0.4.0"]
                 [compojure "1.7.0"]]
  :main clojure-app.core
  :plugins [[lein-ring "0.12.6"]]
  :ring {:handler clojure-app.core/app}
  :profiles {:dev {:dependencies [[ring/ring-mock "0.4.0"]]}}
)
