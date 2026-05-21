--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Folder Events
local Events = ReplicatedStorage:WaitForChild("Events")

--------------------------------------------------
-- UPDATE STATUS : Viewing A Player
--------------------------------------------------

local success1, err1 = pcall(function()
    Events:WaitForChild("UpdatePlayerStatus"):FireServer("[Viewing A Player]")
end)

if not success1 then
    warn("Failed UpdatePlayerStatus:", err1)
end

--------------------------------------------------
-- CHECK VIP SERVER
--------------------------------------------------

local success2, result = pcall(function()
    return Events:WaitForChild("GetIsVIPServer"):InvokeServer()
end)

if success2 then
    print("VIP Server:", result)
else
    warn("Failed GetIsVIPServer:", result)
end

--------------------------------------------------
-- UPDATE STATUS : None
--------------------------------------------------

local success3, err3 = pcall(function()
    Events:WaitForChild("UpdatePlayerStatus"):FireServer("None")
end)

if not success3 then
    warn("Failed Reset Status:", err3)
end

--------------------------------------------------
-- HUMANOID DESCRIPTION
--------------------------------------------------

local humanoidData = {
    ["Properties"] = {
        ["WalkAnimation"] = 133304526526319,
        ["MoodAnimation"] = 14618207727,
        ["Face"] = 0,
        ["ProportionScale"] = 0,
        ["ClimbAnimation"] = 135810009801094,
        ["Shirt"] = 0,
        ["FaceAccessory"] = "110853749962560",

        ["RightArmColor"] = {
            r = 232,
            g = 186,
            b = 170,
            IsRGBTable = true
        },

        ["HairAccessory"] = "16756113551",
        ["RightArm"] = 87722408758201,
        ["Head"] = 126305712746155,
        ["FallAnimation"] = 83937116921114,

        ["TorsoColor"] = {
            r = 232,
            g = 186,
            b = 170,
            IsRGBTable = true
        },

        ["DepthScale"] = 1,
        ["LeftArm"] = 110028702919199,
        ["HeightScale"] = 1.05,
        ["LeftLeg"] = 135801938553962,

        ["RightLegColor"] = {
            r = 232,
            g = 186,
            b = 170,
            IsRGBTable = true
        },

        ["LeftLegColor"] = {
            r = 232,
            g = 186,
            b = 170,
            IsRGBTable = true
        },

        ["WidthScale"] = 1,
        ["BodyTypeScale"] = 1,
        ["RunAnimation"] = 136276875045281,

        ["LeftArmColor"] = {
            r = 232,
            g = 186,
            b = 170,
            IsRGBTable = true
        },

        ["Pants"] = 18925552346,
        ["MakeupItems"] = {},
        ["StaticFacialAnimation"] = false,

        ["WaistAccessory"] = "",
        ["AccessoryRefinements"] = {},
        ["ShouldersAccessory"] = "",
        ["NeckAccessory"] = "",
        ["HatAccessory"] = "",
        ["FrontAccessory"] = "",

        ["SwimAnimation"] = 128475661806875,

        ["HeadColor"] = {
            r = 232,
            g = 186,
            b = 170,
            IsRGBTable = true
        },

        ["BackAccessory"] = "",
        ["IdleAnimation"] = 101839542383818,
        ["Torso"] = 95495113816146,
        ["HeadScale"] = 0.95,
        ["JumpAnimation"] = 130373407996664,
        ["GraphicTShirt"] = 0,
        ["RightLeg"] = 73052027223234,

        ["LayeredAccessories"] = {
            {
                Rotation = {
                    X = 0,
                    Y = 0,
                    Z = 0,
                    Vector3 = true
                },

                AssetId = 94077699740919,
                AccessoryType = "Pants",

                Position = {
                    X = 0,
                    Y = 0,
                    Z = 0,
                    Vector3 = true
                },

                Order = 4,
                IsLayered = true,
                Puffiness = 0.5,

                Scale = {
                    X = 1,
                    Y = 1,
                    Z = 1,
                    Vector3 = true
                }
            },

            {
                Rotation = {
                    X = 0,
                    Y = 0,
                    Z = 0,
                    Vector3 = true
                },

                AssetId = 136980093018484,
                AccessoryType = "Shirt",

                Position = {
                    X = 0,
                    Y = 0,
                    Z = 0,
                    Vector3 = true
                },

                Order = 8,
                IsLayered = true,
                Puffiness = 0.5,

                Scale = {
                    X = 1,
                    Y = 1,
                    Z = 1,
                    Vector3 = true
                }
            }
        }
    },

    ["Action"] = "CreateAndWearHumanoidDescription",
    ["RigType"] = Enum.HumanoidRigType.R15
}

--------------------------------------------------
-- INVOKE CATALOG REMOTE
--------------------------------------------------

local success4, result4 = pcall(function()
    return ReplicatedStorage:WaitForChild("CatalogGuiRemote"):InvokeServer(humanoidData)
end)

if success4 then
    print("HumanoidDescription Applied")
else
    warn("Failed CatalogGuiRemote:", result4)
end
