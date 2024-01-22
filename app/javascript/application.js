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
                                  <td><button type="button" class="btn btn-primary" onclick="selectProductButton(${id}, ${id_model}, '${model_type}')">
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

document.addEventListener("turbo:load", function () {
  $("#buscador_clientes").on("input", function (event) {
    let term = $(this).val();
    let sale_id = $(this).data("venta");

    if (term.length == 0) {
      $("#tabla_buscador_clientes tbody").empty();
    } else {
      let request_url = getRootUrl() + "/client_finder/" + term;

      $.get(request_url, function (data, status) {
        if (data.length > 0) {
          $("#tabla_buscador_clientes tbody").empty();
          for (let x in data) {
            let name = data[x].name;
            let client_id = data[x].id;
            let rowContent = `<tr>
                              <td>${name}</td>
                              <td> <button type="button" class="btn btn-primary" onclick="selectClientButton(${client_id}, ${sale_id})"> 
                              Agregar
                              </button>
                              </td>
                              </tr>`;
            $("#tabla_buscador_clientes tbody").append(rowContent);
          }
        }
      }).fail(function (jqXHR, textStatus, errorThrown) {
        console.error("Error adding client:", textStatus, errorThrown);
      });
    }
  });
});

window.selectClientButton = function (client_id, sale_id) {
  selectClient(client_id, sale_id);
};

window.selectProduct = function (product_id, model_id, model_type) {
  switch (model_type) {
    case "sales":
      addItemSales(product_id, model_id);
      break;
    default:
      break;
  }
};

window.selectProductButton = function (id, id_model, model_type) {
  selectProduct(id, id_model, model_type);
  if ($("#no-product-row").length) {
    $("#no-product-row").remove();
  }
};

function selectClient(client_id, sale_id) {
  if (!client_id) {
    console.error("Client ID are required");
    return;
  }
  if (!sale_id) {
    console.error("Sale ID are required");
    return;
  }

  let request_url = getRootUrl() + "/add_client_sale/";

  let info = {
    client_id: client_id,
    id: sale_id,
  };

  $.ajax({
    url: request_url,
    type: "POST",
    data: JSON.stringify(info),
    contentType: "application/json; charset=utf-8",
    headers: {
      "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content"),
    },
    success: function (result) {
      if (result) {
        $("#buscador_cliente").modal("hide");
        $("body").removeClass("modal-open");
        $(".modal-backdrop").remove();
        let nombre_cliente = result.name;
        $("#cliente_venta").html("Cliente: " + nombre_cliente);
      }
    },
    error: function (jqXHR, textStatus, errorThrown) {
      console.error("Error adding item sale:", textStatus, errorThrown);
    },
  });
}

function addItemSales(product_id, sale_id) {
  if (!product_id || !sale_id) {
    console.error("Product ID and Sale ID are required");
    return;
  }

  let initial_quantity = $("#cantidad_producto").val();
  if (!initial_quantity) {
    console.error("Initial quantity is required");
    return;
  }

  let request_url = getRootUrl() + "/add_item_sale/";

  let info = {
    product_id: product_id,
    id: sale_id,
    quantity: initial_quantity,
  };

  $.ajax({
    url: request_url,
    type: "POST",
    data: JSON.stringify(info),
    contentType: "application/json; charset=utf-8",
    headers: {
      "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content"),
    },
    success: function (result) {
      if (result) {
        $("#buscador_producto").modal("hide");
        $("body").removeClass("modal-open");
        $(".modal-backdrop").remove();
        let quantity = result.quantity;
        let price = result.price;
        let amount_item = result.amount_item;
        let amount_sale = result.amount_sale;
        let name = result.name;
        let newRowContent = `<tr>
        <td>${name}</td>
        <td>${price}</td>
        <td>${quantity}</td>
        <td>$ ${amount_item}</td>
        </tr>`;

        $("#tabla_ventas tbody").append(newRowContent);
        $("#importe_venta_lbl").text("Importe: $" + amount_sale);
      }
    },
    error: function (jqXHR, textStatus, errorThrown) {
      console.error("Error adding item sale:", textStatus, errorThrown);
    },
  });
}

function getRootUrl() {
  return window.location.origin;
}
