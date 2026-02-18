(ns clojure-app.core-test
  (:require [clojure.test :refer :all]
            [clojure-app.core :refer :all]
            [clojure.string :as str]))

(deftest homepage-test
  (testing "homepage returns correct structure"
    (let [{:keys [status headers body]} (homepage)]
      (is (= 200 status))
      (is (= "text/html" (get headers "Content-Type")))
      (is (str/includes? body "<h1>Howdy, World!</h1>")))))
