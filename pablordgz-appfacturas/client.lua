local identifier = "pablordgz-appfacturas"

CreateThread(function ()
    while GetResourceState("lb-phone") ~= "started" do
        Wait(500)
    end

    local function AddApp()
        local added, errorMessage = exports["lb-phone"]:AddCustomApp({
            identifier = identifier,
            name = "Facturas", -- the name of the app
            description = "Aplicación para controlar y pagar tus facturas", -- the description of the app
            developer = "pablordgz", -- OPTIONAL the developer of the app
            defaultApp = true, -- OPTIONAL if set to true, app should be added without having to download it,
            game = false, -- OPTIONAL if set to true, app will be added to the game section
            size = 59812, -- OPTIONAL in kB
            --images = {"https://example.com/photo.jpg"}, -- OPTIONAL array of images for the app on the app store
            ui = "pablordgz-appfacturas/ui/index.html", -- OPTIONAL
            icon = "https://cfx-nui-" .. GetCurrentResourceName() .. "/ui/assets/icon.png", -- OPTIONAL app icon
            --price = 0, -- OPTIONAL, Make players pay with in-game money to download the app
            landscape = false, -- OPTIONAL, if set to true, the app will be displayed in landscape mode
            --keepOpen = true, -- OPTIONAL, if set to true, the app will not close when the player opens the app (only works if ui is not defined)
            onUse = function() -- OPTIONAL function to be called when the app is opened
                TriggerEvent("pablordgz-appfacturas:startApp")
            end,
            })

        if not added then
            print("Could not add app:", errorMessage)
        end
    end

    AddApp()

end)



RegisterNetEvent('pablordgz-appfacturas:startApp')
AddEventHandler('pablordgz-appfacturas:startApp', function()
    TriggerServerEvent("pablordgz-appfacturas:requestFacturas")
end)


RegisterNetEvent('pablordgz-appfacturas:openApp')
AddEventHandler('pablordgz-appfacturas:openApp', function(facturas)
    exports["lb-phone"]:SendCustomAppMessage("pablordgz-appfacturas", {
        type = "open",
        bills = facturas.invoices
    })
end)


RegisterNUICallback("payBill", function(data, cb)
    local billId = data.id
    TriggerServerEvent("pablordgz-appfacturas:payBill", billId)
    cb("ok")
end)

RegisterNetEvent('pablordgz-appfacturas:billPaid')
AddEventHandler('pablordgz-appfacturas:billPaid', function(billId, facturas)
    exports["lb-phone"]:SendCustomAppMessage("pablordgz-appfacturas", {
        type = "reload",
        bills = facturas.invoices
    })
end)