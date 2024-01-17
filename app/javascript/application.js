// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Turbo } from "@hotwired/turbo-rails";
import "controllers";

import "jquery";
import "jquery_ujs";

import "popper";
import "bootstrap";

import "./jquery.min.js";
import "./bootstrap.bundle.js";
import "./sb-admin-2.min.js";

jQuery(document).ready(function () {
  console.log("inside onload action...");
});

document.addEventListener("turbo:load", function () {
  $("#buscador_productos").on("input", function (event) {
    let term = $(this).val();
    let id_model = $(this).data("model");
    let model_type = $(this).data("tipo");

    if (term.length == 0) {
      $("#tabla_buscador tbody").empty();
    } else {
      let request_url = getRootUrl() + "/product_finder/" + term;

      $.get(request_url, function (data, status) {
        if (data.length > 0) {
          $("#tabla_buscador tbody").empty();
          for (let x in data) {
            let name = data[x].name;
            let existence = data[x].existence;
            let id = data[x].id;
            let newRowContent = `<tr>
                                  <td>${name}</td>
                                  <td>${existence}</td>
                                  <td><button type="button" class="btn btn-primary" onclick="seleccionarProducto(${id}, ${id_model}, '${model_type}')">
                                    Agregar
                                    </button>
                                  </td>
                                </tr>`;
            $("#tabla_buscador tbody").append(newRowContent);
          }
        }
      });
    }
  });
});

function getRootUrl() {
  return window.location.origin;
}
