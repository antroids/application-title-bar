/*
 * SPDX-FileCopyrightText: 2025 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import "config/effect/"
import "config/effect/effect.js" as EffectUtils
import QtQuick

Repeater {
    id: effectsRepeater

    model: plasmoid.configuration.effects

    property var effectRules: []

    function updateEffectRules() {
        let rulesList = [];
        for (var i = 0; i < plasmoid.configuration.effectRules.length; i++) {
            const ruleModel = JSON.parse(plasmoid.configuration.effectRules[i]);
            const rule = EffectUtils.Condition.fromModel(ruleModel);
            rulesList[i] = rule;
        }
        effectRules = rulesList;
        updateEffectsState();
    }

    function updateEffectsState() {
        var effectsState = [];
        for (var i = 0; i < effectsRepeater.effectRules.length; i++) {
            if (!effectsState[i]) {
                const rule = effectsRepeater.effectRules[i];
                effectsState[rule.effectIndex] = rule.checkCondition(root);
            }
        }
        for (var i = 0; i < effectsRepeater.count; i++) {
            const item = effectsRepeater.itemAt(i);
            if (item) {
                item.opacity = effectsState[i] ? 1.0 : 0.0;
            }
        }
    }

    MergedMultiEffect {
        anchors.fill: widgetRow
        source: widgetRow
        opacity: 0.0
        visible: opacity !== 0.0

        required property int index
        required property var modelData

        onModelDataChanged: function () {
            effectModel.updateFromJson(modelData);
        }

        Behavior on opacity {
            NumberAnimation {
                duration: plasmoid.configuration.widgetButtonsAnimation
            }
        }
    }
}
