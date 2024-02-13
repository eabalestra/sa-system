// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Turbo } from "@hotwired/turbo-rails";
import "controllers";

import "jquery";
import "jquery_ujs";
import "popper";
import "bootstrap";
import "sb_admin";

import "./jquery.min.js";
import "./jquery.easing.min.js";
import "./bootstrap.bundle.js";

import "chartkick";
import "Chart.bundle";

// Functions
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
            <td><button type="button" class="btn btn-primary" onclick="getDiscountAndSelectProduct(${id}, ${id_model}, '${model_type}')">
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

document.addEventListener("turbo:load", function () {
  $("#buscador_proveedores").on("input", function (event) {
    let term = $(this).val();
    let purchase_id = $(this).data("purchase");

    if (term.length == 0) {
      $("#tabla_buscador_proveedores tbody").empty();
    } else {
      let request_url = getRootUrl() + "/supplier_finder/" + term;

      $.get(request_url, function (data, status) {
        if (data.length > 0) {
          $("#tabla_buscador_proveedores tbody").empty();
          for (let x in data) {
            let name = data[x].name;
            let supplier_id = data[x].id;
            let rowContent = `<tr>
                              <td>${name}</td>
                              <td> <button type="button" class="btn btn-primary" onclick="selectSupplierButton(${supplier_id}, ${purchase_id})"> 
                              Agregar
                              </button>
                              </td>
                              </tr>`;
            $("#tabla_buscador_proveedores tbody").append(rowContent);
          }
        }
      }).fail(function (jqXHR, textStatus, errorThrown) {
        console.error("Error adding supplier:", textStatus, errorThrown);
      });
    }
  });
});

window.getDiscountAndSelectProduct = function(id, id_model, model_type) {
  let discount = $("#discount").val();
  selectProductButton(id, id_model, model_type, discount);
}

window.selectClientButton = function (client_id, sale_id) {
  selectClient(client_id, sale_id);
};

window.selectSupplierButton = function (supplier_id, purchase_id) {
  addSupplierPurchase(supplier_id, purchase_id);
};

window.selectProduct = function (product_id, model_id, model_type, discount) {
  switch (model_type) {
    case "sales":
      addItemSales(product_id, model_id, discount);
      break;
    case "purchases":
      addItemPurchase(product_id, model_id);
      break;
    default:
      break;
  }
};

window.selectProductButton = function (id, id_model, model_type, discount) {
  selectProduct(id, id_model, model_type, discount);
  if ($("#no-product-row").length) {
    $("#no-product-row").remove();
  }
};

function addSupplierPurchase(supplier_id, purchase_id) {
  if (!supplier_id) {
    console.error("Supplier ID are required");
    return;
  }
  if (!purchase_id) {
    console.error("Purchase ID are required");
    return;
  }

  let request_url = getRootUrl() + "/add_supplier_purchase/";

  let info = {
    supplier_id: supplier_id,
    id: purchase_id,
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
        $("#buscador_proveedor").modal("hide");
        $("body").removeClass("modal-open");
        $(".modal-backdrop").remove();
        let nombre_proveedor = result.supplier_name;
        $("#proveedor_compra").html("Proveedor: " + nombre_proveedor);
      }
    },
    error: function (jqXHR, textStatus, errorThrown) {
      console.error("Error adding supplier purchase:", textStatus, errorThrown);
    },
  });
}

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

function addItemSales(product_id, sale_id, discount) {
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
    discount: discount,
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
        let discount = result.discount;
        let amount_item_after_discount = amount_item - (amount_item * discount);
        let newRowContent = `<tr>
        <td>${name}</td>
        <td>${price}</td>
        <td>${quantity}</td>
        <td>$ ${amount_item}</td>
        <td>${(discount*100).toFixed(2)}%</td>
        <td>$ ${amount_item_after_discount} </td>
        </tr>`;

        $("#tabla_ventas tbody").append(newRowContent);
        $("#importe_venta_lbl").text("Importe: $" + amount_sale);
      }
    },
    error: function (jqXHR, textStatus, errorThrown) {
      if (jqXHR.responseJSON && jqXHR.responseJSON.message) {
        alert(jqXHR.responseJSON.message);
      } else {
        console.error("Error adding item sale:", textStatus, errorThrown);
      }
    },
  });
}

function addItemPurchase(product_id, purchase_id) {
  if (!product_id || !purchase_id) {
    console.error("Product ID and Purchase ID are required");
    return;
  }

  let initial_quantity = $("#cantidad_producto").val();
  let unit_cost = $("#unit_cost").val();

  if (!initial_quantity) {
    console.error("Initial quantity is required");
    return;
  }

  let request_url = getRootUrl() + "/add_item_purchase/";

  let info = {
    product_id: product_id,
    id: purchase_id,
    quantity: initial_quantity,
    unit_cost: unit_cost,
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
        let price_at_purchase = result.price_at_purchase;
        let amount_item = result.amount_item;
        let amount_purchase = result.amount_purchase;
        let name = result.name;
        let newRowContent = `<tr>
        <td>${name}</td>
        <td>${price_at_purchase}</td>
        <td>${quantity}</td>
        <td>$ ${amount_item}</td>
        </tr>`;

        $("#tabla_compras tbody").append(newRowContent);
        $("#importe_compra_lbl").text("Importe: $" + amount_purchase);
      }
    },
    error: function (jqXHR, textStatus, errorThrown) {
      console.error("Error adding item purchase:", textStatus, errorThrown);
    },
  });
}

function getRootUrl() {
  return window.location.origin;
}
