(ns clojure-app.core-test
  (:require [clojure.test :refer :all]
            [ring.mock.request :as mock]
            [clojure-app.core :refer :all]))

(deftest homepage-test
  (testing "GET / returns 200 and contains Howdy"
    (let [response (app (mock/request :get "/"))]
      (is (= 200 (:status response)))
      (is (.contains (:body response) "<h1>Howdy, World!</h1>")))))
