﻿using UnityEngine;
        Button btn = GetComponent<Button>();
        if (btn)
        {
            btn.onClick.AddListener(() => Do());
        }
        {
            Toggle tgl = GetComponent<Toggle>();
            tgl.onValueChanged.AddListener((value) => Do());
        }
    }