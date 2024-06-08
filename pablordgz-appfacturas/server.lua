RegisterNetEvent('pablordgz-appfacturas:requestFacturas')
AddEventHandler('pablordgz-appfacturas:requestFacturas', function()
    local src = source
    local facturas = exports.pefcl:getInvoices(src).data
    Citizen.Wait(150)
    TriggerClientEvent('pablordgz-appfacturas:openApp', src, facturas)
end)

function payMoney(xPlayer, xTarget, src, result, invoice)
    exports.pefcl:addBankBalanceByIdentifier(src, {identifier = result.receiverAccountIdentifier, amount = result.amount, message = "Factura pagada"})
    MySQL.update('UPDATE pefcl_invoices SET status = ? WHERE id = ?', {"PAID", invoice.id})
    xPlayer.showNotification('Has pagado la factura', "bank")
    local newBills = exports.pefcl:getInvoices(src).data
    TriggerClientEvent('pablordgz-appfacturas:billPaid', src, invoice.id, newBills)
    if xTarget then
        xTarget.showNotification('Te han pagado una factura', "bank")
    end
end

RegisterNetEvent('pablordgz-appfacturas:payBill')
AddEventHandler('pablordgz-appfacturas:payBill', function(billId)
    
    local src = source
    local invoices = exports.pefcl:getInvoices(src).data
    local cid = ESX.GetPlayerFromId(src).getIdentifier()
    for i = 1, #invoices.invoices do
        if invoices.invoices[i].id == tonumber(billId) and invoices.invoices[i].status ~= "PAID" then
            
            local invoice = invoices.invoices[i]
            MySQL.single("SELECT id, amount, receiverAccountIdentifier, fromIdentifier, message FROM pefcl_invoices WHERE id = ?", {tonumber(invoice.id)}, 
                function(result)
                    if result then
                        local xPlayer = ESX.GetPlayerFromId(src)
                        local xTarget = ESX.GetPlayerFromIdentifier(result.fromIdentifier)
                        if xPlayer.getMoney() >= result.amount then
                            xPlayer.removeMoney(result.amount, "Factura")
                            payMoney(xPlayer, xTarget, src, result, invoice)
                        elseif xPlayer.getAccount('bank').money >= result.amount then
                            xPlayer.removeAccountMoney('bank', result.amount, "Factura")
                            payMoney(xPlayer, xTarget, src, result, invoice)
                        else
                            xPlayer.showNotification('No tienes suficiente dinero', "bank")
                        end
                    end
                end)
            break
        end
    end
end)
