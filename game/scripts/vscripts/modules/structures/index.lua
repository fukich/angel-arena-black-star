ModuleRequire(..., "data")
ModuleRequire(..., "shops")
Structures = Structures or class({})

function Structures:AddHealers()
	for _,v in ipairs(Entities:FindAllByClassname("npc_dota_healer")) do
		local model = TEAM_HEALER_MODELS[v:GetTeamNumber()]
		v:SetOriginalModel(model.mdl)
		v:SetModel(model.mdl)
		if model.color then v:SetRenderColor(unpack(model.color)) end
		v:RemoveModifierByName("modifier_invulnerable")
		v:AddNewModifier(v, nil, "modifier_arena_healer", nil)
	end
end

function Structures:GiveCourier(hero)
	local pid = hero:GetPlayerID()
	local tn = hero:GetTeamNumber()
	local cour_item = hero:AddItem(CreateItem("item_courier", hero, hero))
	TEAMS_COURIERS[hero:GetTeamNumber()] = true
	Timers:CreateTimer(0.03, function()
		if IsValidEntity(owner)  then
			for _,courier in ipairs(Entities:FindAllByClassname("npc_dota_courier")) do
				local owner = courier:GetOwner()
				if owner:GetPlayerID() == pid then
					courier:SetOwner(nil)
					courier:UpgradeToFlyingCourier()

					courier:AddNewModifier(courier, nil, "modifier_arena_courier", nil)
					courier:RemoveAbility("courier_burst")

					TEAMS_COURIERS[tn] = courier
				end
			end
		end
	end)
end