$(function GetPreco() {
    $("#produtos").change(function () {
        $.ajax({
            type: "Get",
            url: "/PedidosItens/GetPreco?produtoId=" + $(this).val(),
            success: (data) => {

                $("#preco").val(data.toString().replace('.', ','));

                GetTotal();
            },
            error: (response) => {
                console.log(response.responseText)
            }
        });
    });
});

function GetTotal() {

    let quantidade = $("#quantidade").val();
    let preco = $("#preco").val();

    quantidade = parseFloat(quantidade.replace('.', '').replace(',', '.'));
    preco = parseFloat(preco.replace('.', '').replace(',', '.'));

    let total = quantidade * parseFloat(preco);

    $("#total").val(FormatNumber(total));
}

function FormatNumber(number) {

    number = number.toString().replace('.', ',');
    number = number.replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1.')

    return number;
}