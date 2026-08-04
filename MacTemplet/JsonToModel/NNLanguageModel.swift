//
//  NNLanguageModel.swift
//  MacTemplet
//
//  Created by ESJsonFormatForMac on 19/06/22.
//

import Foundation

@objcMembers
class NNLanguageModel: NSObject, NSSecureCoding {

    var arrayType: String?
    var basicTypesWithSpecialFetchingNeeds: [Any]?
    var booleanGetter: String?
    var briefDescription: String?
    var constructors: [Any]?
    var dataTypes: NNDatatypesModel?
    var defaultParentWithUtilityMethods: String?
    var displayLangName: String?
    var fileExtension: String?
    var genericType: String?
    var getter: String?
    var importForEachCustomType: String?
    var instanceVarDefinition: String?
    var langName: String?
    var podName: String?
    var modelDefinition: String?
    var modelDefinitionWithParent: String?
    var modelEnd: String?
    var modelStart: String?
    var reservedKeywords: [Any]?
    var setter: String?
    var staticImports: String?
    var supportsFirstLineStatement: String?
    var utilityMethods: [NNUtilitymethodsModel]?
    var wordsToRemoveToGetArrayElementsType: [Any]?

    static var supportsSecureCoding: Bool { true }

    static func modelContainerPropertyGenericClass() -> [String: Any]? {
        return ["utilityMethods": NNUtilitymethodsModel.classForCoder()]
    }

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init()
        arrayType = coder.decodeObject(of: NSString.self, forKey: #keyPath(arrayType)) as String?
        basicTypesWithSpecialFetchingNeeds = coder.decodeObject(
            of: [NSArray.self, NSString.self],
            forKey: #keyPath(basicTypesWithSpecialFetchingNeeds)
        ) as? [Any]
        booleanGetter = coder.decodeObject(of: NSString.self, forKey: #keyPath(booleanGetter)) as String?
        briefDescription = coder.decodeObject(of: NSString.self, forKey: #keyPath(briefDescription)) as String?
        constructors = coder.decodeObject(
            of: [NSArray.self, NSString.self],
            forKey: #keyPath(constructors)
        ) as? [Any]
        dataTypes = coder.decodeObject(of: NNDatatypesModel.self, forKey: #keyPath(dataTypes))
        defaultParentWithUtilityMethods = coder.decodeObject(
            of: NSString.self,
            forKey: #keyPath(defaultParentWithUtilityMethods)
        ) as String?
        displayLangName = coder.decodeObject(of: NSString.self, forKey: #keyPath(displayLangName)) as String?
        fileExtension = coder.decodeObject(of: NSString.self, forKey: #keyPath(fileExtension)) as String?
        genericType = coder.decodeObject(of: NSString.self, forKey: #keyPath(genericType)) as String?
        getter = coder.decodeObject(of: NSString.self, forKey: #keyPath(getter)) as String?
        importForEachCustomType = coder.decodeObject(
            of: NSString.self,
            forKey: #keyPath(importForEachCustomType)
        ) as String?
        instanceVarDefinition = coder.decodeObject(
            of: NSString.self,
            forKey: #keyPath(instanceVarDefinition)
        ) as String?
        langName = coder.decodeObject(of: NSString.self, forKey: #keyPath(langName)) as String?
        podName = coder.decodeObject(of: NSString.self, forKey: #keyPath(podName)) as String?
        modelDefinition = coder.decodeObject(of: NSString.self, forKey: #keyPath(modelDefinition)) as String?
        modelDefinitionWithParent = coder.decodeObject(
            of: NSString.self,
            forKey: #keyPath(modelDefinitionWithParent)
        ) as String?
        modelEnd = coder.decodeObject(of: NSString.self, forKey: #keyPath(modelEnd)) as String?
        modelStart = coder.decodeObject(of: NSString.self, forKey: #keyPath(modelStart)) as String?
        reservedKeywords = coder.decodeObject(
            of: [NSArray.self, NSString.self],
            forKey: #keyPath(reservedKeywords)
        ) as? [Any]
        setter = coder.decodeObject(of: NSString.self, forKey: #keyPath(setter)) as String?
        staticImports = coder.decodeObject(of: NSString.self, forKey: #keyPath(staticImports)) as String?
        supportsFirstLineStatement = coder.decodeObject(
            of: NSString.self,
            forKey: #keyPath(supportsFirstLineStatement)
        ) as String?
        utilityMethods = coder.decodeObject(
            of: [NSArray.self, NNUtilitymethodsModel.self],
            forKey: #keyPath(utilityMethods)
        ) as? [NNUtilitymethodsModel]
        wordsToRemoveToGetArrayElementsType = coder.decodeObject(
            of: [NSArray.self, NSString.self],
            forKey: #keyPath(wordsToRemoveToGetArrayElementsType)
        ) as? [Any]
    }

    func encode(with coder: NSCoder) {
        coder.encode(arrayType, forKey: #keyPath(arrayType))
        coder.encode(basicTypesWithSpecialFetchingNeeds, forKey: #keyPath(basicTypesWithSpecialFetchingNeeds))
        coder.encode(booleanGetter, forKey: #keyPath(booleanGetter))
        coder.encode(briefDescription, forKey: #keyPath(briefDescription))
        coder.encode(constructors, forKey: #keyPath(constructors))
        coder.encode(dataTypes, forKey: #keyPath(dataTypes))
        coder.encode(defaultParentWithUtilityMethods, forKey: #keyPath(defaultParentWithUtilityMethods))
        coder.encode(displayLangName, forKey: #keyPath(displayLangName))
        coder.encode(fileExtension, forKey: #keyPath(fileExtension))
        coder.encode(genericType, forKey: #keyPath(genericType))
        coder.encode(getter, forKey: #keyPath(getter))
        coder.encode(importForEachCustomType, forKey: #keyPath(importForEachCustomType))
        coder.encode(instanceVarDefinition, forKey: #keyPath(instanceVarDefinition))
        coder.encode(langName, forKey: #keyPath(langName))
        coder.encode(podName, forKey: #keyPath(podName))
        coder.encode(modelDefinition, forKey: #keyPath(modelDefinition))
        coder.encode(modelDefinitionWithParent, forKey: #keyPath(modelDefinitionWithParent))
        coder.encode(modelEnd, forKey: #keyPath(modelEnd))
        coder.encode(modelStart, forKey: #keyPath(modelStart))
        coder.encode(reservedKeywords, forKey: #keyPath(reservedKeywords))
        coder.encode(setter, forKey: #keyPath(setter))
        coder.encode(staticImports, forKey: #keyPath(staticImports))
        coder.encode(supportsFirstLineStatement, forKey: #keyPath(supportsFirstLineStatement))
        coder.encode(utilityMethods, forKey: #keyPath(utilityMethods))
        coder.encode(wordsToRemoveToGetArrayElementsType, forKey: #keyPath(wordsToRemoveToGetArrayElementsType))
    }
}

@objcMembers
class NNDatatypesModel: NSObject, NSSecureCoding {

    var boolType: String?
    var characterType: String?
    var doubleType: String?
    var floatType: String?
    var intType: String?
    var longType: String?
    var stringType: String?

    static var supportsSecureCoding: Bool { true }

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init()
        boolType = coder.decodeObject(of: NSString.self, forKey: #keyPath(boolType)) as String?
        characterType = coder.decodeObject(of: NSString.self, forKey: #keyPath(characterType)) as String?
        doubleType = coder.decodeObject(of: NSString.self, forKey: #keyPath(doubleType)) as String?
        floatType = coder.decodeObject(of: NSString.self, forKey: #keyPath(floatType)) as String?
        intType = coder.decodeObject(of: NSString.self, forKey: #keyPath(intType)) as String?
        longType = coder.decodeObject(of: NSString.self, forKey: #keyPath(longType)) as String?
        stringType = coder.decodeObject(of: NSString.self, forKey: #keyPath(stringType)) as String?
    }

    func encode(with coder: NSCoder) {
        coder.encode(boolType, forKey: #keyPath(boolType))
        coder.encode(characterType, forKey: #keyPath(characterType))
        coder.encode(doubleType, forKey: #keyPath(doubleType))
        coder.encode(floatType, forKey: #keyPath(floatType))
        coder.encode(intType, forKey: #keyPath(intType))
        coder.encode(longType, forKey: #keyPath(longType))
        coder.encode(stringType, forKey: #keyPath(stringType))
    }
}

@objcMembers
class NNUtilitymethodsModel: NSObject, NSSecureCoding {

    var propertyMapModelMethod: String?
    var propertyMapPropertyMethod: String?

    static var supportsSecureCoding: Bool { true }

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init()
        propertyMapModelMethod = coder.decodeObject(
            of: NSString.self,
            forKey: #keyPath(propertyMapModelMethod)
        ) as String?
        propertyMapPropertyMethod = coder.decodeObject(
            of: NSString.self,
            forKey: #keyPath(propertyMapPropertyMethod)
        ) as String?
    }

    func encode(with coder: NSCoder) {
        coder.encode(propertyMapModelMethod, forKey: #keyPath(propertyMapModelMethod))
        coder.encode(propertyMapPropertyMethod, forKey: #keyPath(propertyMapPropertyMethod))
    }
}
