<template>
  <div class="tab-content" :style="colorStyle" >
    <div class="tab-item-wrap" v-for="(tab, index) in navList" :key="('tab' + index)">
      <div class="tab-item-content" @click="onTabClick(index)">
        <div class="tab-item-text-container">
          <p :class="(chosenIndex === index) ? 'tab-item-text-selected' : 'tab-item-text' ">ssssssss{{tab}}</p>
        </div>

        <div :class="(chosenIndex === index) ? 'tab-item-indicator-selected' : 'tab-item-indicator' "></div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "Tab",

  data() {
    return {
      chosenIndex: 0,
      navList: ['选基金', '选基金', '选基金', '选基金', '选基金', '选基金', '选基金', '选基金', '澳网', '电影', '本地', '娱乐', '小说', '生活', '直播', '游戏'],
    }
  },

  computed: {
    colorStyle() {
      let op1 = 0;
      return {
        borderWidth: 0.5 + 'px',
        borderBottomColor: `rgba(0, 0, 0, ${op1})`,
      }
    }
  },

  methods: {
    onTabClick(i) {
      this.chosenIndex = i;
      this.$emit("onTabClick", {
        index: i
      });
    },

    setChosenIndex(i) {
      if (i !== this.chosenIndex) {
        this.chosenIndex = i;
      }
    },
  },

  mounted() {
  }
}
</script>

<style scoped>
.tab-content {
  display: flex;
  flex-direction: row;
  flex: 1;
  background-color: #F7F7F7;
}

.tab-item-content {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.tab-item-wrap {
  display: flex;
  flex-direction: row;
  margin-left: 20px;
}

.tab-item-text-container {
  height: 25px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  //width: 115px;
}

.tab-item-text {
  font-style: normal;
  font-weight: 400;
  font-size: 16px;
  color: rgba(0, 0, 0, 0.65);
  //width: 114px;
}

.tab-item-text-selected {
  font-style: normal;
  font-weight: 500;
  font-size: 18px;
  color: #000000;
}

.tab-item-indicator {
  width: 1px;
  height: 0;
  margin-top: 6px;
  background-color: transparent;
}

.tab-item-indicator-selected {
  width: 18px;
  height: 4px;
  margin-top: 6px;
  background-color: #2470EB;
}
</style>
